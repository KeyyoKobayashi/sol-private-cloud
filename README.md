# GitHub Update Publishing Guide

This folder is prepared for publishing a new Sol Private Cloud update.

## 1) Update the manifest values

Open [github-update/update-manifest.json](update-manifest.json) and replace the placeholders:

- version: use a new version number, for example 2.5.1
- minimum_version: usually keep the current minimum supported release, such as 2.4.3
- download_url: replace with your GitHub release asset URL
- sha256: replace with the real SHA-256 of the ZIP file
- release_notes: add a short summary
- published_at: set the release date

Example:

```json
{
  "version": "2.5.1",
  "minimum_version": "2.4.3",
  "download_url": "https://github.com/YOUR-USERNAME/YOUR-REPO/releases/download/v2.5.1/sol-private-cloud-cinematic-2.5.1.zip",
  "sha256": "REPLACE_WITH_64_CHAR_SHA256",
  "release_notes": "Bug fixes and reliability improvements.",
  "required": false,
  "published_at": "2026-09-17T00:00:00Z"
}
```

## 2) Build the ZIP package

From the project root, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\github-update\build-update-package.ps1 -Version 2.5.1
```

This creates a file like:

```text
github-update\sol-private-cloud-cinematic-2.5.1.zip
```

The ZIP must contain the app files and top-level project files that the updater expects, including:

- app/
- run.py
- requirements.txt
- start.bat
- update_runner.py
- release-manifest.json

## 3) Generate the ZIP checksum

Run:

```powershell
Get-FileHash .\github-update\sol-private-cloud-cinematic-2.5.1.zip -Algorithm SHA256
```

Copy the hash into the manifest JSON under sha256.

## 4) Upload to GitHub

1. Open your GitHub repository.
2. Create a new Release.
3. Set the tag to something like: v2.5.1
4. Upload the ZIP file as a release asset.
5. Upload the manifest file as a public release asset too, or host it somewhere public.
6. Copy the direct download URL for the ZIP and put it in the manifest.

Example direct asset URL:

```text
https://github.com/YOUR-USERNAME/YOUR-REPO/releases/download/v2.5.1/sol-private-cloud-cinematic-2.5.1.zip
```

## 5) Point the app at the manifest

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

## 6) Notes

- The manifest URL must be a public HTTPS URL.
- The ZIP must be a real app package, not a random file.
- Version numbers must increase correctly, for example 2.5.0 -> 2.5.1.
- Keep minimum_version at or below the current supported minimum to avoid compatibility blocks.

If you want, rename the upload files to match your actual repository name before publishing.
