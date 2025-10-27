. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'NVAccess.NVDA'
$wingetPackage = (Find-WinGetPackage -Id $packageName -Count 1)
$wingetVersion = $wingetPackage.Version
$url = "https://api.nvaccess.org/nvdaUpdateCheck?autoCheck=False&allowUsageStats=False&version=$wingetVersion&versionType=stable&x64=True"
Write-Information "Getting most recent version from NVAccess using $($wingetVersion) as reference version"
$result = Invoke-RestMethod -Uri $url
if ($result -Ne [String]::Empty) {
    $mostRecentVersion = ($result | Select-String '\sversion: (.+)').Matches.Groups[1].Value
    Write-Information "Most recent version available is version $($mostRecentVersion)"
    if ((Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
        $launcherUrl = ($result | Select-String 'launcherUrl: (.+)').Matches.Groups[1].Value
        Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -urls $launcherUrl -Submit
    }
}
else {
    Write-Information 'No update available'
}
