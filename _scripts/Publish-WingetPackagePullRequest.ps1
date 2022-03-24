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
		$Submit,
		[string]
		$Token = $env:GITHUB_PERSONAL_ACCESS_TOKEN
	)
	$execStr = (where.exe wingetcreate.exe)
	$execStr += " update $PackageName --version $version -u $([String]::Join(' ', $urls))"
	if ($Submit) {
		$execStr += " -s"
	}
	if (![String]::IsNullOrWhitespace($token)) {
		$execStr += " -t $token"
	}
	write-warning $execStr
	Invoke-Expression $execStr
}
