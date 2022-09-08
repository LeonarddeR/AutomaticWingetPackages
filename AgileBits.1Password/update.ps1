. $PSScriptRoot\..\_scripts\all.ps1

$packageName = "AgileBits.1Password"
$wingetVersion = (Get-WingetLastPackageVersion $packageName)
$latestExeUrl = "https://downloads.1password.com/win/1PasswordSetup-latest.exe"
$localExePath = "$($env:TEMP)\1PasswordSetup-latest.exe"
Invoke-RestMethod -Uri $latestExeUrl -OutFile $localExePath
$mostRecentVersion = (get-itemproperty $localExePath).VersionInfo.ProductVersion
if ($mostRecentVersion -Gt $wingetVersion -and (Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
    Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -urls https://downloads.1password.com/win/1PasswordSetup-$($mostRecentVersion).exe, https://downloads.1password.com/win/1PasswordSetup-$($mostRecentVersion).msi
}