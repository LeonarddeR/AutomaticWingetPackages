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
	$execStr = (where.exe wingetcreate.exe)
	$execStr += " update $PackageName --version $version -u $([String]::Join(' ', $urls))"
	if ($Submit) {
		$execStr += ' -s'
	}
	Write-Information "Executing: $($execStr)"
	if (![String]::IsNullOrWhitespace($token)) {
		$execStr += " -t $token"
	}
	Invoke-Expression $execStr
}
