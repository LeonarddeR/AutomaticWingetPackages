. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'Cockos.REAPER'
$wingetVersion = (Get-WingetLastPackageVersion $packageName)
Write-Information "Downloading release notes from Cockos using $($wingetVersion) as reference version"
$url = "https://cockos.com/reaper/latestversion?version=$wingetVersion"
$result = Invoke-RestMethod -Uri $url
$mostRecentVersion = ($result -SPlit '\n')[0]
$shortVersion = $mostRecentVersion -Replace '\.'
Write-Information "Most recent version available is version $($mostRecentVersion ). Comparing against version $($wingetVersion) in WinGet repository"
if ([Version]$mostRecentVersion -Gt [Version]$wingetVersion -and (Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
    Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -urls https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)_x64-install.exe, https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)-install.exe, https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)_win11_arm64ec_beta-install.exe
}
