# From https://github.com/actions/virtual-environments/issues/910#issuecomment-1009640391
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'
Set-StrictMode -Version latest

function Get-PackageUriFromAdguard([String]$package, $architecture = 'x64') {
	$packageSplit = $package.Split('_')
	$packageMatch = "$($packageSplit[0])_.+_$($architecture)__$($packageSplit[1]).appx"
	$res = Invoke-WebRequest 'https://store.rg-adguard.net/api/GetFiles' -Method 'POST' -ContentType 'application/x-www-form-urlencoded' -Body "type=PackageFamilyName&url=$package&ring=RP&lang=en-US" -UseBasicParsing
	return $res | ForEach-Object Links | Where-Object outerHTML -Match $packageMatch | ForEach-Object href
}

Invoke-WebRequest -Uri (Get-PackageUriFromAdguard('Microsoft.VCLibs.140.00_8wekyb3d8bbwe')) -OutFile $env:TEMP\vclibs.appx
Invoke-WebRequest -Uri (Get-PackageUriFromAdguard('Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe')) -OutFile $env:TEMP\vclibsuwp.appx
Invoke-WebRequest -Uri (Get-PackageUriFromAdguard('Microsoft.UI.Xaml.2.7_8wekyb3d8bbwe')) -OutFile $env:TEMP\xaml.appx
Invoke-WebRequest 'https://github.com/microsoft/winget-cli/releases/download/v1.3.2091/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile $env:TEMP\winget.msixbundle
Invoke-WebRequest 'https://github.com/microsoft/winget-cli/releases/download/v1.3.2091/7b91bd4a0be242d6aa8e8da282b26297_License1.xml' -OutFile $env:TEMP\winget.license

Add-AppxProvisionedPackage -Online -PackagePath $env:TEMP\winget.msixbundle -LicensePath $env:TEMP\winget.license -DependencyPackagePath @("$env:TEMP\vclibs.appx", "$env:TEMP\vclibsuwp.appx", "$env:TEMP\xaml.appx")