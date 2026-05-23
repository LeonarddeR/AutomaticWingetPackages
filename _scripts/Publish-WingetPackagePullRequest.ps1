function Publish-WingetPackagePullRequest {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName,
		[Parameter(Mandatory)]
		[string]
		$Version,
		[Parameter(Mandatory)]
		[string[]]
		$Urls,
		[Switch]
		$Submit = $true,
		[string]
		$Token = $env:GITHUB_PERSONAL_ACCESS_TOKEN
	)
	$exe = (Get-Command wingetcreate.exe).Source
	$argList = @('update', $PackageName, '--version', $Version, '-u') + $Urls
	if ($Submit) { $argList += '-s' }
	Write-Information "Executing: $exe $($argList -join ' ')"
	if (-not [String]::IsNullOrWhiteSpace($Token)) { $argList += @('-t', $Token) }
	& $exe @argList
}
