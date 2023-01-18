function Get-WingetLastPackageVersion {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]
		$PackageName
	)
	Write-Information "Getting last package version for $($PackageName)"
	# Construct a path from the package name
	$path = "winget-pkgs\manifests\$($PackageName[0])\$($PackageName.Replace('.', '\'))"
	Write-Information "Inspecting $($path) for packages"
	$yamls = Get-ChildItem -Path "$($path)\*\$($PackageName).yaml" | Sort-Object { [Version]$_.Directory.Name }
	Write-Information "$($yamls.count) versions found"
	$version = $yamls[-1].Directory.Name
	Write-Information "Last version of $($PackageName) in WinGet repository is version $($version)"
	return $version
}
