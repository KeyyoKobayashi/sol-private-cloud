# Sol Private Cloud

Sol Private Cloud is a Windows-first, self-hosted personal cloud for people
who want a polished file workspace without handing their files to a third-
party storage provider.

Your files stay on folders you choose. The application stores file metadata in
SQLite, provides a responsive browser interface, and gives administrators
explicit control over users, drives, permissions, sharing, updates, and remote
access.

## Why Sol Cloud?

- **Your storage, your machine:** files remain on your selected Windows drives.
- **A real workspace:** list and grid views, previews, search, favorites, trash,
  sharing, version history, transfers, and a responsive mobile layout.
- **Designed for safe roots:** drives are detected but disabled until an admin
  chooses a dedicated folder such as `D:\SolCloud`.
- **Multi-user permissions:** use `ADMIN`, `USER`, or `READ_ONLY` accounts with
  drive and folder-level permissions.
- **Resumable transfers:** uploads use chunks, retries, temporary files, and
  atomic final moves.
- **Private sharing:** links can have passwords, expiration dates, download
  limits, and can be disabled at any time.
- **Built-in update center:** admins can receive release notifications,
  verify checksums, stage updates, install them, and roll back failed updates.
- **Optional HTTPS access:** the included ngrok integration can expose the
  server through an HTTPS URL without changing the storage model.

## Current Release

Download the latest release from:

<https://github.com/KeyyoKobayashi/sol-private-cloud/releases>

Download the ZIP asset named `sol-private-cloud-cinematic-<version>.zip`.
Do not download `update-manifest.json` as an installer; that file is used by
existing installations to discover updates.

## Requirements

- Windows 10 or Windows 11
- Python 3.11 or newer
- Optional: an ngrok account and `ngrok.exe` for remote HTTPS access

Install Python from <https://www.python.org/downloads/windows/> and enable
**Add Python to PATH** during setup.

## Installation

1. Open the [latest release](https://github.com/KeyyoKobayashi/sol-private-cloud/releases).
2. Download `sol-private-cloud-cinematic-<version>.zip`.
3. Extract it to a private folder, for example `C:\SolCloud`.
4. Double-click `install.bat`.
5. Double-click `start.bat`.
6. Complete the first-run setup with an administrator username, password, and
   cloud name.

The installer creates a local Python virtual environment and installs the
required dependencies. The application opens in your browser after startup.

You can also start it from PowerShell:

```powershell
cd C:\SolCloud
.\.venv\Scripts\python.exe .\run.py
```

Do not run `app\updater.py` directly. It is an internal package module and is
loaded by the main application.

## Configure Storage

After signing in as the administrator:

1. Open **Administration -> Drives**.
2. Select **Configure** for a detected drive.
3. Choose a dedicated folder such as `D:\SolCloud` or `E:\PrivateFiles`.
4. Enable **Create root if missing** if needed.
5. Enable the drive.

Do not use the root of a drive or sensitive folders such as `C:\Windows`,
`Program Files`, browser profiles, or application-data directories.

No drive is accessible until an administrator explicitly configures and enables
it.

## Remote HTTPS Access With ngrok

Remote access is optional. For local-only use, run the application without
ngrok.

To enable HTTPS access:

1. Download `ngrok.exe` from <https://ngrok.com/download>.
2. Place it in the Sol Cloud project folder, or install it on `PATH`.
3. Run the authentication command shown in your ngrok dashboard:

```bat
ngrok config add-authtoken YOUR_TOKEN
```

4. Start the application with `start.bat`.

The launcher starts FastAPI and ngrok together, discovers the public HTTPS URL,
updates the local environment settings, and opens the remote address. Keep the
startup window open while the server is running. Press `Ctrl+C` to stop it.

Never share your ngrok token. Do not set `ALLOWED_HOSTS=*` on an internet-
accessible installation.

## Users and Permissions

- `ADMIN`: manage the application, users, drives, permissions, updates, and all
  permitted files.
- `USER`: normal file access controlled by drive and folder permissions.
- `READ_ONLY`: view, preview, download, and favorite by default.

Administrators can control viewing, uploading, downloading, deleting,
renaming, moving, copying, sharing, favoriting, previewing, and folder
creation. Drive policies remain authoritative.

## Updates

The update center is administrator-controlled. It does not silently replace
your application.

On the installed application, open **Administration -> Updates** and set this
stable manifest URL:

```text
https://github.com/KeyyoKobayashi/sol-private-cloud/releases/latest/download/update-manifest.json
```

Enable automatic checks and save the settings. When a newer compatible release
is published:

1. Enabled admin accounts receive an in-app notification.
2. The admin opens **Review Update**.
3. The app downloads the ZIP and verifies its SHA-256 checksum.
4. The admin chooses the installation action.
5. The updater backs up the managed files, installs the staged package, checks
   the new version, and rolls back if verification fails.

Updates preserve local `data`, `.env`, `.venv`, and `ngrok.exe`. The stable
`latest` URL means existing installations continue discovering future releases
without changing the URL each time.

## Security and Data Model

- Files remain in your configured filesystem roots.
- SQLite stores metadata, accounts, sessions, settings, and activity records;
  it does not store file contents.
- Passwords are hashed and sessions use secure random secrets.
- Paths are normalized and checked against their configured safe root.
- Traversal, absolute paths, device names, unsafe names, symlinks, and Windows
  reparse points are rejected.
- Uploads are checked against drive policy and blocked extensions.
- HTML, JavaScript, and SVG previews are displayed as text rather than trusted
  application content.
- Updates require public HTTPS manifests and exact SHA-256 verification.
- Backups include application metadata and secrets but intentionally exclude
  user files.

This is defense in depth, not a replacement for Windows security software.
Keep Microsoft Defender, Windows, Python, dependencies, and ngrok updated.

## Backups

From **Administration -> System**, download an application backup. It contains
the SQLite database, session secret, and a versioned manifest. User files are
not included.

Back up each configured storage root separately with your normal backup tool.
To restore an application backup while the server is stopped:

```bat
.venv\Scripts\python.exe restore_backup.py path\to\sol-cloud-backup.zip
```

## Architecture

- **Backend:** FastAPI and Uvicorn
- **Database:** SQLite with WAL mode and foreign keys
- **Frontend:** dependency-free HTML, CSS, and JavaScript SPA
- **Search:** background metadata indexing with SQLite queries
- **Transfers:** resumable chunked uploads and disk-backed ZIP downloads
- **Realtime:** authenticated WebSocket events
- **Deployment:** Windows batch and PowerShell launchers

## Development

```bat
.venv\Scripts\activate
python -m unittest discover -s tests -v
python run.py
```

The interactive API documentation is disabled by default. Set `DEBUG=true` in
`.env` to expose `/api/docs` for local development.

## Project Layout

```text
sol-cloud/
├─ app/                   Application backend and static frontend
├─ data/                  Local database, update state, logs, and temporary data
├─ tests/                 Regression and feature tests
├─ install.bat            First-time dependency installer
├─ start.bat              Windows launcher
├─ stop.bat               Local shutdown helper
├─ run.py                 FastAPI entry point
├─ update_runner.py       Backup, install, verify, and rollback runner
├─ restore_backup.py      Backup validation and restore tool
├─ requirements.txt       Python dependencies
└─ .env.example           Safe configuration template
```

## License

See [LICENSE](LICENSE).

## Support and Contributions

Please include your Windows version, Python version, application version, and
relevant logs when reporting a problem. Never include passwords, ngrok tokens,
session secrets, database files, or private file contents in an issue.
