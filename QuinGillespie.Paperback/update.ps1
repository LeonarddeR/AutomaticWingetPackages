. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'QuinGillespie.Paperback'
$wingetPackage = (Find-WinGetPackage -Id $packageName -Count 1)
$wingetVersion = $wingetPackage.Version
Write-Information 'Getting latest stable release from GitHub'
$headers = @{ Accept = 'application/vnd.github+json' }
if (-not [String]::IsNullOrWhiteSpace($env:GITHUB_PERSONAL_ACCESS_TOKEN)) {
    $headers['Authorization'] = "Bearer $env:GITHUB_PERSONAL_ACCESS_TOKEN"
}
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/trypsynth/paperback/releases/latest' -Headers $headers
$mostRecentVersion = $release.tag_name
Write-Information "Most recent version available is version $($mostRecentVersion). Comparing against version $($wingetVersion) in WinGet repository"
if ([Version]$wingetVersion -lt [Version]$mostRecentVersion -and (Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
    $urls = foreach ($arch in 'x64', 'arm64') {
        $asset = $release.assets | Where-Object name -Eq "paperback_setup-$arch.exe"
        if (-not $asset) {
            throw "Release $mostRecentVersion has no $arch installer"
        }
        # wingetcreate takes '<url>|<arch>' to force the installer architecture
        "$($asset.browser_download_url)|$arch"
    }
    Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -Urls $urls
}
