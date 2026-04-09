# ─────────────────────────────────────────────────────────────────────────────
# install.ps1  —  Sapi Installer for Windows
#
# Usage: Right-click → "Run with PowerShell", or:
#   powershell.exe -ExecutionPolicy Bypass -File install.ps1
#
# What it does:
#   1. Installs sapi.exe  → %LOCALAPPDATA%\sapi\bin\  (added to PATH)
# ─────────────────────────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$scriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Definition
$binSrc      = Join-Path $scriptDir "sapi.exe"
$sapiInstall = Join-Path $env:LOCALAPPDATA "sapi\bin"

Write-Host ""
Write-Host "  Sapi — Windows Installer" -ForegroundColor Cyan
Write-Host "  ─────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ── Install sapi.exe ──────────────────────────────────────────────────────────
if (-not (Test-Path $binSrc)) {
    Write-Host "  [ERROR] sapi.exe not found in this folder." -ForegroundColor Red
    exit 1
}

Write-Host "  Installing sapi.exe  →  $sapiInstall" -ForegroundColor White
New-Item -ItemType Directory -Force $sapiInstall | Out-Null
Copy-Item -Force $binSrc (Join-Path $sapiInstall "sapi.exe")

$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$sapiInstall*") {
    [Environment]::SetEnvironmentVariable("PATH", "$userPath;$sapiInstall", "User")
    Write-Host "  Added to PATH  (re-open your terminal to use 'sapi')" -ForegroundColor Green
} else {
    Write-Host "  Already in PATH" -ForegroundColor DarkGray
}

# ── Done ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  Done!  Run: sapi new <project-name>" -ForegroundColor Green
Write-Host ""
