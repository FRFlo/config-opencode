#!/usr/bin/env bash
# setup.sh - Bootstrap OpenCode configuration from remote (macOS / Linux)
# Run via: curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash

set -euo pipefail

BRANCH="${BRANCH:-develop}"
ZIP_URL="https://github.com/FRFlo/config-opencode/archive/refs/heads/$BRANCH.zip"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PRIMARY_DIR="$HOME/.opencode"
XDG_DIR="$XDG_CONFIG_HOME/opencode"
LEGACY_PLUGIN_DIR="$HOME/.opencode/config"
BACKUP_ROOT="$HOME/.opencode-config-backups/$(date +%Y%m%d-%H%M%S)-$$"
STAGING_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

# OpenCode / oh-my-openagent have used several config locations across setups.
# If we only write one directory, an older file in another location may stay active
# and make this installer look like it did nothing. Back up every known location,
# then install the fresh config to all supported locations.
TARGET_DIRS=(
  "$PRIMARY_DIR"
  "$XDG_DIR"
  "$LEGACY_PLUGIN_DIR"
)

KNOWN_CONFIG_FILES=(
  "$HOME/.opencode/opencode.json"
  "$HOME/.opencode/oh-my-openagent.json"
  "$HOME/.opencode/config/opencode.json"
  "$HOME/.opencode/config/oh-my-openagent.json"
  "$XDG_CONFIG_HOME/opencode/opencode.json"
  "$XDG_CONFIG_HOME/opencode/oh-my-openagent.json"
)

backup_existing_file() {
  local src="$1"

  if [ ! -f "$src" ] && [ ! -L "$src" ]; then
    return 0
  fi

  local rel
  rel="${src#$HOME/}"
  local dest="$BACKUP_ROOT/$rel"

  mkdir -p "$(dirname "$dest")"
  mv "$src" "$dest"
  echo "Backed up existing config: $src -> $dest"
}

install_directory() {
  local dir="$1"
  
  mkdir -p "$dir"
  cp -R "$extracted_root/"* "$dir/"
  echo "Installed config files to: $dir"
}

echo "Preparing OpenCode configuration replacement..."
echo "Primary target: $PRIMARY_DIR"
echo "Compatibility targets: $XDG_DIR, $LEGACY_PLUGIN_DIR"

echo "Downloading: $ZIP_URL"
curl -fsSL "$ZIP_URL" -o "$STAGING_DIR/repo.zip"

echo "Extracting archive..."
unzip -q "$STAGING_DIR/repo.zip" -d "$STAGING_DIR"

extracted_root=$(find "$STAGING_DIR" -mindepth 1 -maxdepth 1 -type d)
rm -f "$extracted_root/setup.sh" "$extracted_root/setup.ps1" "$extracted_root/README.md"
rm -f "$extracted_root/repo.zip"

echo "Replacing existing configs..."

for existing in "${KNOWN_CONFIG_FILES[@]}"; do
  backup_existing_file "$existing"
done

for dir in "${TARGET_DIRS[@]}"; do
  install_directory "$dir"
done

echo ""
if [ -d "$BACKUP_ROOT" ]; then
  echo "Previous configs were backed up in: $BACKUP_ROOT"
else
  echo "No previous OpenCode config files found to back up."
fi

echo "Done. OpenCode configuration replaced."