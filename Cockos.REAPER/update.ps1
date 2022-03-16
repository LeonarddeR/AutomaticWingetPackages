. $PSScriptRoot\..\_scripts\all.ps1

$packageName = "Cockos.REAPER"
$wingetVersion = (Get-WingetLastPackageVersion $packageName)
$url = "https://cockos.com/reaper/latestversion?version=$wingetVersion"
$result = Invoke-RestMethod -Uri $url
$mostRecentVersion = $result.SubString(0, 4)
$shortVersion = $mostRecentVersion -Replace '\.'
if ($mostRecentVersion -Gt $wingetVersion) {
    wingetcreate update $packageName --version $mostRecentVersion -u https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)_x64-install.exe, https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)-install.exe
}