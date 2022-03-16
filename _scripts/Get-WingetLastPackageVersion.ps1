function Get-WingetLastPackageVersion {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName
	)
	$result = (winget show -e $PackageName) | Select-String "version: (.+)"
	return $result.Matches.Groups[1].Value
}
