function Get-WingetLastPackageVersion {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName
	)
	# Construct a path from the package name
	$path = "winget-pkgs\manifests\$($PackageName[0])\$($PackageName.Replace('.', '\'))"
	$yamls = Get-ChildItem -Path "$($path)\*\$($PackageName).yaml"
	return $yamls[-1].Directory.Name
}
