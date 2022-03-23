function Get-WingetPullRequestCount {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName,
		[Parameter(Mandatory)]
		[string]
		$Version
	)
	$result = Invoke-RestMethod -Uri "https://api.github.com/search/issues?q=repo%3Amicrosoft%2Fwinget-pkgs+is%3Apr+`"$PackageName+$Version`"+in%3Atitle" -Headers @{Accept = 'application/vnd.github.v3.text-match+json' }
	return $result.total_count
}
