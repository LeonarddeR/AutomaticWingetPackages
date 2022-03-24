function Get-WingetLastPackageVersion {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName
	)
	$result = (winget show --accept-source-agreements -e $PackageName) | Select-String "version: (.+)"
	Write-Information $result
	return $result.Matches.Groups[1].Value
}
