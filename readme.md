![Build status](https://github.com/leonardder/AutomaticWingetPackages/actions/workflows/winget-submission.yml/badge.svg)

This repository facilitates automatic updates for packages in de repository of [the Windows Package Manager CLI (aka winget)](https://github.com/microsoft/winget-cli). Packages are submitted on behalf of [@LeonarddeR](https://github.com/leonardder/).

## Packages

### Cockos.REAPER
[REAPER](http://reaper.fm/) is a digital audio production application, offering full multitrack audio and MIDI recording, processing, editing, mixing and mastering toolset.

Update checking takes place by polling the REAPER update endpoint, passing the version that is currently the latest version available in de winget repository.

### NVAccess.NVDA
[NonVisual Desktop Access (NVDA)](https://www.nvaccess.org/) is a free and open source screen reader for the Microsoft Windows operating system. Providing feedback via synthetic speech and Braille, it enables blind or vision impaired people to access computers running Windows for no more cost than a sighted person. NVDA is developed by NV Access, with contributions from the community.

Update checking takes place by polling the NVDA update endpoint, comparing the version  against the version that is currently the latest version available in de winget repository.

### AgileBits.1Password
[1Password](https://1password.com/) is a commercial password manager that allows you to store and use strong passwords.

Update checking occurs by downloading the most recent version of 1Password, which is always behind de same URL.
The most recent version string is then determined from the product version of the installer executable.
[This approach was proposed in the Chocolatey community packages repository](https://github.com/chocolatey-community/chocolatey-packages/issues/1773#issuecomment-1128465417).
The determined version  will be compared against the version that is currently the latest version available in de winget repository.

## Contributing
Feel free to fork this repository for yourself.
Note that the publishing process relies on a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
You can also file an issue to suggest package additions.
Only those applications will be supported that have a reliable method to determine the most recent app version.
