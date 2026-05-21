# setup.ps1 - Bootstrap OpenCode configuration from remote
# Run via: irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex

$ErrorActionPreference = "Stop"

$BaseUrl  = "https://github.com/FRFlo/config-opencode/raw/refs/heads/develop"
$TargetDir = Join-Path $env:USERPROFILE ".config\opencode"
$Files     = @("opencode.json", "oh-my-openagent.json")

if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Host "Created: $TargetDir"
} else {
    Write-Host "Already exists: $TargetDir"
}

foreach ($File in $Files) {
    $Url         = "$BaseUrl/$File"
    $Destination = Join-Path $TargetDir $File
    Write-Host "Downloading: $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing
    Write-Host "  -> $Destination"
}

Write-Host "`nDone. OpenCode configuration bootstrapped."
