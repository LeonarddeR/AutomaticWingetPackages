function Get-WingetPullRequestCount {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName,
		[Parameter(Mandatory)]
		[string]
		$Version,
		[string]
		$AdditionalCriteria
	)
	Write-Information "Getting pull request for package $($PackageName) version $($Version)"
	$uri = "https://api.github.com/search/issues?q=repo%3Amicrosoft%2Fwinget-pkgs+is%3Apr+`"$PackageName+$Version`"+in%3Atitle"
	if (-not [String]::IsNullOrWhiteSpace($AdditionalCriteria)) {
		$uri += "+$([System.Web.HttpUtility]::UrlEncode($AdditionalCriteria))"
	}
	$headers = @{ Accept = 'application/vnd.github.v3.text-match+json' }
	if (-not [String]::IsNullOrWhiteSpace($env:GITHUB_PERSONAL_ACCESS_TOKEN)) {
		$headers['Authorization'] = "Bearer $env:GITHUB_PERSONAL_ACCESS_TOKEN"
	}
	$result = Invoke-RestMethod -Uri $uri -Headers $headers
	$count = $result.total_count
	Write-Information "Found $($count) pull requests for $($PackageName) $($Version)"
	return $count
}
