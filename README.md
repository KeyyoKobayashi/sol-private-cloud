# GitHub Update Publishing Guide

## One-command release

The generator now builds the ZIP, calculates its SHA-256, writes
`update-manifest.json`, remembers the repository, and can publish the GitHub
Release automatically.

From the project root, first update `app/__init__.py` to the new version, then run:

```powershell
python .\github-update\generate_release.py
```

On the first run, enter your GitHub username and repository name. They are
saved locally in `github-update/release-config.json`, so future releases only
ask for the version. Choose `y` when asked to publish.

Automatic publishing uses GitHub CLI. Install it from `https://cli.github.com/`
and sign in once:

```powershell
gh auth login
```

The script never asks for or stores a GitHub password or token.

The generator creates these files in this folder:

- `sol-private-cloud-cinematic-<version>.zip`
- `update-manifest.json`

It replaces files with the same version, so you do not need to delete them manually.

Use the stable manifest URL printed by the generator in the app settings:

```text
https://github.com/<username>/<repository>/releases/latest/download/update-manifest.json
```

This keeps existing installations pointed at the newest GitHub Release. Older
tag-specific manifest URLs are also upgraded automatically when the updater
checks them.

This folder is prepared for publishing a new Sol Private Cloud update.

## Requirements

Before generating a release, change `__version__` in `app/__init__.py` to the
same version you will enter. The generator intentionally checks this so an
update cannot be published with a mismatched application version.

The ZIP includes the complete application and installer files needed on a new
Windows computer. User data, `.env`, `.venv`, and `ngrok.exe` are not included
or overwritten.

To install from a published release, download the ZIP asset, extract it, and
double-click `install.bat`. Then put `ngrok.exe` in the extracted folder if
remote HTTPS access is needed, and start the application with `start.bat`.

## Point the app at the manifest

In the Sol Private Cloud admin area:

- Go to Administration → Updates
- Set Manifest URL to the public URL for the JSON file
- Enable automatic checks if desired
- Save the settings

The app will then:

- fetch the manifest
- compare versions
- warn admins if a newer release is available
- verify the ZIP checksum before installing
- back up the current install and roll back on failure

## Notes

- The manifest URL must be a public HTTPS URL.
- The ZIP must be created by `generate_release.py`.
- Version numbers must increase correctly, for example 2.5.0 -> 2.5.1.
- Keep minimum_version at or below the current supported minimum to avoid compatibility blocks.
