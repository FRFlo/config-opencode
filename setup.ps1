# setup.ps1 - Bootstrap OpenCode configuration from remote
# Run via: irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex

param(
    [string]$Flavor
)

$ErrorActionPreference = "Stop"

$BaseUrl   = "https://github.com/FRFlo/config-opencode/raw/refs/heads/develop"
$TargetDir = Join-Path $HOME ".config/opencode"
$Files     = @("opencode.json", "oh-my-openagent.json")
$ValidFlavors = @("cheap", "perf")

function Resolve-Flavor {
    param(
        [string]$RequestedFlavor
    )

    if ($RequestedFlavor -and $ValidFlavors -contains $RequestedFlavor.ToLowerInvariant()) {
        return $RequestedFlavor.ToLowerInvariant()
    }

    if ($env:OPENCODE_PROFILE -and $ValidFlavors -contains $env:OPENCODE_PROFILE.ToLowerInvariant()) {
        return $env:OPENCODE_PROFILE.ToLowerInvariant()
    }

    Write-Host "Select the OpenCode profile to install:"
    Write-Host "  1) cheap  - OpenCode Go + OpenAI"
    Write-Host "  2) perf   - OpenAI only"

    while ($true) {
        $Choice = Read-Host "Enter 1 or 2 (default: 1)"

        if ([string]::IsNullOrWhiteSpace($Choice) -or $Choice -eq "1") {
            return "cheap"
        }

        if ($Choice -eq "2") {
            return "perf"
        }

        Write-Host "Invalid selection. Please choose 1 or 2."
    }
}

$Flavor = Resolve-Flavor -RequestedFlavor $Flavor
$ProfileUrl = "$BaseUrl/$Flavor"

if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Host "Created: $TargetDir"
} else {
    Write-Host "Already exists: $TargetDir"
}

Write-Host "Installing profile: $Flavor"

foreach ($File in $Files) {
    $Url = "$ProfileUrl/$File"
    $Destination = Join-Path $TargetDir $File
    Write-Host "Downloading: $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Destination
    Write-Host "  -> $Destination"
}

Write-Host "`nDone. OpenCode configuration bootstrapped with '$Flavor'."
