param(
    [string]$Version = "2.5.1",
    [string]$ProjectRoot = (Get-Location).Path
)

$root = (Resolve-Path $ProjectRoot).Path
$zipName = "sol-private-cloud-cinematic-$Version.zip"
$zipPath = Join-Path $root "github-update\$zipName"

$files = @(
    (Join-Path $root "app"),
    (Join-Path $root "run.py"),
    (Join-Path $root "requirements.txt"),
    (Join-Path $root "start.bat"),
    (Join-Path $root "update_runner.py"),
    (Join-Path $root "release-manifest.json")
)

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path $files -DestinationPath $zipPath -Force
Write-Host "Created update package: $zipPath"
