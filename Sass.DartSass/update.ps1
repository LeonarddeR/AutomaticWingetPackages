. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'Sass.DartSass'
$repo = 'sass/dart-sass'

# Get current version from WinGet repository
$wingetPackage = Find-WinGetPackage -Id $packageName -Count 1
$wingetVersion = $wingetPackage.Version

Write-Information "Current version in WinGet: $wingetVersion"
Write-Information "Querying GitHub for latest release of $packageName"

# GitHub API latest release call
$release = Invoke-RestMethod `
    -Uri "https://api.github.com/repos/$repo/releases/latest" `
    -Headers @{ 'User-Agent' = 'WinGetUpdaterScript' }

# Extract version (remove leading v)
$mostRecentVersion = $release.tag_name.TrimStart('v')

Write-Information "Newest upstream version: $mostRecentVersion"

# Compare versions
if ([Version]$mostRecentVersion -le [Version]$wingetVersion) {
    Write-Information "No update needed. Latest version ($mostRecentVersion) is not newer than WinGet version ($wingetVersion)."
    return
}

# Check for existing PR
if ((Get-WingetPullRequestCount $packageName $mostRecentVersion) -ne 0) {
    Write-Information "A pull request already exists for version $mostRecentVersion."
    return
}

# Extract Windows ZIP assets
$windowsAssets = $release.assets | Where-Object { $_.name -match 'windows.*\.zip$' } | Select-Object -ExpandProperty browser_download_url

if (-not $windowsAssets) {
    Write-Error "No Windows ZIP releases found for $mostRecentVersion!"
    return
}

Write-Information "Windows ZIP assets found:`n$($windowsAssets -join "`n")"
Write-Information 'Submitting WinGet update PR...'

Publish-WingetPackagePullRequest `
    -PackageName $packageName `
    -Version $mostRecentVersion `
    -urls $windowsAssets `
    -Submit
