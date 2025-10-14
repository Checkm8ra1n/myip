$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

# Find python
$pythonCmd = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $pythonCmd) { $pythonCmd = (Get-Command python3 -ErrorAction SilentlyContinue).Source }
if (-not $pythonCmd) {
    Write-Error "Python not found in PATH."
    exit 1
}
Write-Output "Using Python: $pythonCmd"

# Ensure pip is available
& $pythonCmd -m pip --version > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "pip not found, attempting to enable ensurepip..."
    & $pythonCmd -m ensurepip --upgrade > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "pip is not available and ensurepip failed."
        exit 1
    }
}

# Install PyInstaller if missing
& $pythonCmd -m pip show pyinstaller > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Output "Installing PyInstaller..."
    & $pythonCmd -m pip install --user pyinstaller
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install PyInstaller."
        exit 1
    }
}

# Build single-file executable
Write-Output "Building single-file executable with PyInstaller..."
& $pythonCmd -m PyInstaller --onefile --name myip myip.py
if ($LASTEXITCODE -ne 0) {
    Write-Error "PyInstaller build failed."
    exit 1
}

$distExe = Join-Path $scriptDir "dist\myip.exe"
if (Test-Path $distExe) {
    Copy-Item $distExe -Destination (Join-Path $scriptDir "myip.exe") -Force
    Write-Output "Created: myip.exe"
    # Optional cleanup
    Remove-Item -Recurse -Force build dist myip.spec -ErrorAction SilentlyContinue
} else {
    Write-Error "Executable not found at dist\myip.exe"
    exit 1
}