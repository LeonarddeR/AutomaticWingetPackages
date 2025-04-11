# From https://github.com/actions/virtual-environments/issues/910#issuecomment-1009640391
$ErrorActionPreference = 'Stop'
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

Invoke-WebRequest 'https://github.com/microsoft/winget-cli/releases/download/v1.10.340/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -OutFile $env:TEMP\winget.msixbundle
Invoke-WebRequest 'https://github.com/microsoft/winget-cli/releases/download/v1.10.340/4df037184d634a28b13051a797a25a16_License1.xml' -OutFile $env:TEMP\winget.license

Add-AppxProvisionedPackage -Online -PackagePath $env:TEMP\winget.msixbundle -LicensePath $env:TEMP\winget.license