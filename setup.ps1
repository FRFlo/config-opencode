# setup.ps1 - Bootstrap OpenCode configuration from remote
# Run via: irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex

$ErrorActionPreference = "Stop"

$Branch = "develop"
$ZipUrl = "https://github.com/FRFlo/config-opencode/archive/refs/heads/$Branch.zip"
$TargetDir = Join-Path $env:USERPROFILE ".config\opencode"
$TempZip = Join-Path $env:TEMP "config-opencode.zip"
$ExtractDir = Join-Path $env:TEMP "config-opencode-extract"

if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Host "Created: $TargetDir"
}

Write-Host "Downloading: $ZipUrl"
Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing

if (Test-Path -LiteralPath $ExtractDir) {
    Remove-Item -LiteralPath $ExtractDir -Recurse -Force
}
New-Item -ItemType Directory -Path $ExtractDir | Out-Null

Write-Host "Extracting archive..."
Expand-Archive -Path $TempZip -DestinationPath $ExtractDir -Force

$ExtractedRoot = Get-ChildItem -LiteralPath $ExtractDir | Select-Object -First 1

Remove-Item -Path "$($ExtractedRoot.FullName)\setup.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$($ExtractedRoot.FullName)\setup.sh" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$($ExtractedRoot.FullName)\README.md" -Force -ErrorAction SilentlyContinue

Write-Host "Copying files to $TargetDir..."
Copy-Item -Path "$($ExtractedRoot.FullName)\*" -Destination $TargetDir -Recurse -Force

Remove-Item -Path $TempZip -Force
Remove-Item -Path $ExtractDir -Recurse -Force

Write-Host "`nDone. OpenCode configuration bootstrapped."
