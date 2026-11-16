. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'CLARATION.Impactor.CLI'
$wingetPackage = (Find-WinGetPackage -Id $packageName -Count 1)
$wingetVersion = $wingetPackage.Version
Write-Information 'Getting latest stable release from GitHub'
$headers = @{ Accept = 'application/vnd.github+json' }
if (-not [String]::IsNullOrWhiteSpace($env:GITHUB_PERSONAL_ACCESS_TOKEN)) {
    $headers['Authorization'] = "Bearer $env:GITHUB_PERSONAL_ACCESS_TOKEN"
}
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/claration/impactor/releases/latest' -Headers $headers
$mostRecentVersion = $release.tag_name -replace '^v'
Write-Information "Most recent version available is version $($mostRecentVersion). Comparing against version $($wingetVersion) in WinGet repository"
if ([Version]$wingetVersion -lt [Version]$mostRecentVersion -and (Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
    $assetArchitectures = [ordered]@{ 'x86' = 'x86'; 'x86_64' = 'x64'; 'arm64' = 'arm64' }
    $urls = foreach ($assetArch in $assetArchitectures.Keys) {
        $arch = $assetArchitectures[$assetArch]
        $asset = $release.assets | Where-Object name -Eq "plumesign-windows-$assetArch.exe"
        if (-not $asset) {
            throw "Release $mostRecentVersion has no $arch installer"
        }
        # wingetcreate takes '<url>|<arch>' to force the installer architecture
        "$($asset.browser_download_url)|$arch"
    }
    Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -Urls $urls -ReleaseNotesUrl $release.html_url -ReleaseDate $release.published_at
}
