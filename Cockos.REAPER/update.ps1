. $PSScriptRoot\..\_scripts\all.ps1

$packageName = 'Cockos.REAPER'
$wingetPackage = (Find-WinGetPackage -Id $packageName -Count 1)
$wingetVersion = $wingetPackage.Version
Write-Information "Downloading release notes from Cockos using $($wingetVersion) as reference version"
$url = "https://cockos.com/reaper/latestversion?version=$wingetVersion"
$result = Invoke-RestMethod -Uri $url
$mostRecentVersion = ($result -SPlit '\n')[0]
$shortVersion = $mostRecentVersion -Replace '\.'
Write-Information "Most recent version available is version $($mostRecentVersion ). Comparing against version $($wingetVersion) in WinGet repository"
if ($wingetVersion -lt [Version]$mostRecentVersion -and (Get-WingetPullRequestCount $packageName $mostRecentVersion) -Eq 0) {
    $releaseNotesUrl = 'https://www.reaper.fm/whatsnew.txt'
    $releaseNotes = Invoke-RestMethod -Uri $releaseNotesUrl
    $releaseDate = $null
    $parsedDate = [datetime]::MinValue
    # Headings look like 'v7.86 - November 13 2026'
    if ($releaseNotes -match "(?m)^v$([regex]::Escape($mostRecentVersion)) - (.+?)\s*$" -and
        [datetime]::TryParseExact($Matches[1], 'MMMM d yyyy', [cultureinfo]::InvariantCulture, 'None', [ref]$parsedDate)) {
        $releaseDate = $parsedDate
    }
    else {
        Write-Information "No release date found for version $($mostRecentVersion) in $($releaseNotesUrl)"
    }
    Publish-WingetPackagePullRequest -PackageName $packageName -Version $mostRecentVersion -urls https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)_x64-install.exe, https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)-install.exe, https://www.reaper.fm/files/$($shortVersion[0]).x/reaper$($shortVersion)_win11_arm64ec_beta-install.exe -ReleaseNotesUrl $releaseNotesUrl -ReleaseDate $releaseDate
}
