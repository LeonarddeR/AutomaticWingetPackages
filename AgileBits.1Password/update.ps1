[CmdletBinding()]
param(
    [String]$ForceVersion = $null
)
. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'AgileBits.1Password'
$wingetPackage = (Find-WinGetPackage -Id $packageName -Count 1)
$wingetVersion = $wingetPackage.Version
if ($Null -Eq $ForceVersion) {
    $latestExeUrl = 'https://downloads.1password.com/win/1PasswordSetup-latest.exe'
    $localExePath = "$($env:TEMP)\1PasswordSetup-latest.exe"
    Write-Information "Downloading most recent executable for $($PackageName)"
    Invoke-RestMethod -Uri $latestExeUrl -OutFile $localExePath
    $mostRecentVersion = ((Get-ItemProperty $localExePath).VersionInfo.ProductVersion -split '\.')[0..2] -join '.'
}
else {
    $mostRecentVersion = $ForceVersion
}
Write-Information "Most recent version downloaded is version $($mostRecentVersion ). Comparing against version $($wingetVersion) in WinGet repository"
if ([Version]$mostRecentVersion -Gt [Version]$wingetVersion -and (Get-WingetPullRequestCount $packageName $mostRecentVersion -AdditionalCriteria 'NOT beta in:title') -Eq 0) {
    Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -urls https://downloads.1password.com/win/1PasswordSetup-$($mostRecentVersion).exe, https://downloads.1password.com/win/1PasswordSetup-$($mostRecentVersion).msi
}
