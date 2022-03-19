. $PSScriptRoot\..\_scripts\all.ps1

$packageName = "NVAccess.NVDA"
$wingetVersion = (Get-WingetLastPackageVersion $packageName)
$url = "https://www.nvaccess.org/nvdaUpdateCheck?autoCheck=False&allowUsageStats=False&version=$wingetVersion&versionType=stable&osVersion=10.0.17763&x64=True"
$result = Invoke-RestMethod -Uri $url
if ($result -Ne [String]::Empty) {
    $mostRecentVersion = ($result | Select-String "version: (.+)").Matches.Groups[1].Value
    if ((Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
        $launcherUrl = ($result | Select-String "launcherUrl: (.+)\?update=1").Matches.Groups[1].Value
        Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -urls $launcherUrl -Submit
    }
}
