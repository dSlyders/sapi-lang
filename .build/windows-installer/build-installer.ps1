param(
    [Parameter(Mandatory = $true)]
    [string]$SourceExe,

    [Parameter(Mandatory = $true)]
    [string]$OutputDir,

    [Parameter(Mandatory = $false)]
    [string]$AppVersion = "0.0.0"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourceExe)) {
    throw "Source executable not found: $SourceExe"
}

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$issPath = Join-Path $scriptDir "sapi-installer.iss"

if (-not (Test-Path $issPath)) {
    throw "Inno Setup script not found: $issPath"
}

$isccCmd = Get-Command iscc.exe -ErrorAction SilentlyContinue
if (-not $isccCmd) {
    Write-Host "iscc.exe not found. Install Inno Setup and add it to PATH. Skipping installer generation." -ForegroundColor Yellow
    exit 0
}

$outputBase = "sapi-setup-$AppVersion"

$isccArgs = @(
    "/DAppVersion=$AppVersion"
    "/DSourceExe=$SourceExe"
    "/DOutputDir=$OutputDir"
    "/DOutputBaseFilename=$outputBase"
    $issPath
)

& $isccCmd.Source @isccArgs

if ($LASTEXITCODE -ne 0) {
    throw "Inno Setup build failed with code $LASTEXITCODE"
}

Write-Host "Installer generated: $OutputDir\\$outputBase.exe" -ForegroundColor Green
