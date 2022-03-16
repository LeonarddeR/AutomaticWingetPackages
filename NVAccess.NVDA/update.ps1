. $PSScriptRoot\..\_scripts\all.ps1

# This uRL is used by NVDA's update checker and returns a download URL for the latest version
# We request an update from version 2019.2, which returns the latest version as of now. If this changes in the future, we might need to make the version dynamic.
$url    = 'https://www.nvaccess.org/nvdaUpdateCheck?autoCheck=False&allowUsageStats=False&version=2019.2&versionType=stable&osVersion=10.0.17763&x64=True'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')"= "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]fileType\s*=\s*)('.*')"   = "`$1'$($Latest.FileType)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }

        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+file:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(checksum:).*"        = "`${1} $($Latest.Checksum32)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases | Select -ExpandProperty Content

    $url = $download_page -split "`n" -match "launcherUrl:" -split ": " | Select -last 1
    # URL contains ?update=1 by default, let's strip this
    $url = $url -split "\?update" | Select -first 1

    $version = $url -split '_|.exe' | Select -Last 1 -Skip 1

    $releaseNotes = $download_page -split "`n" -match "changesUrl:" -split ": " | Select -Last 1

    $checksum32 = $download_page -split "`n" -match "launcherHash:" -split ": " | Select -Last 1

    return @{
        URL32        = $url
        Checksum32   = $checksum32
	       ChecksumType32 = 'md5'
        Version      = $version
        ReleaseNotes = $releaseNotes
    }
}

update -ChecksumFor none
