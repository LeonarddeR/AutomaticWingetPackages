![Build status](https://github.com/leonardder/AutomaticWingetPackages/actions/workflows/winget-submission.yml/badge.svg)

This repository facilitates automatic updates for packages in de repository of [the Windows Package Manager CLI (aka winget)](https://github.com/microsoft/winget-cli). Packages are submitted on behalf of [@LeonarddeR](https://github.com/leonardder/).

## Packages

### CLARATION.Impactor.CLI
[Impactor CLI](https://github.com/claration/impactor) (plumesign) is the command-line interface of Impactor, an iOS code signing and inspection tool.

Update checking takes place by querying the latest stable GitHub release, comparing its tag against the version currently in the winget repository. The x86, x64 and arm64 portable executables are submitted.

### Cockos.REAPER
[REAPER](http://reaper.fm/) is a digital audio production application, offering full multitrack audio and MIDI recording, processing, editing, mixing and mastering toolset.

Update checking takes place by polling the REAPER update endpoint, passing the version that is currently the latest version available in de winget repository.

### QuinGillespie.Paperback
[Paperback](https://github.com/trypsynth/paperback) is an accessible, light-weight, cross-platform ebook and document reader.

Update checking takes place by querying the latest stable GitHub release, comparing its tag against the version currently in the winget repository. The x64 and arm64 installers are submitted.

## Contributing
Feel free to fork this repository for yourself.
Note that the publishing process relies on a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
You can also file an issue to suggest package additions.
Only those applications will be supported that have a reliable method to determine the most recent app version.
