#!/usr/bin/env bash
# setup.sh - Bootstrap OpenCode configuration from remote (macOS / Linux)
# Run via: curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash

set -euo pipefail

BASE_URL="${BASE_URL:-https://github.com/FRFlo/config-opencode/raw/refs/heads/develop}"
FILES=("opencode.json" "oh-my-openagent.json")

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

download_file() {
  local file="$1"
  local url="$BASE_URL/$file"
  local staged="$STAGING_DIR/$file"

  echo "Downloading: $url"
  curl -fsSL "$url" -o "$staged"
  echo "  -> staged $file"
}

install_file() {
  local file="$1"
  local dir="$2"
  local src="$STAGING_DIR/$file"
  local dest="$dir/$file"

  mkdir -p "$dir"
  cp "$src" "$dest"
  echo "Installed: $dest"
}

echo "Preparing OpenCode configuration replacement..."
echo "Primary target: $PRIMARY_DIR"
echo "Compatibility targets: $XDG_DIR, $LEGACY_PLUGIN_DIR"

for file in "${FILES[@]}"; do
  download_file "$file"
done

echo "All config files downloaded successfully. Replacing existing configs..."

for existing in "${KNOWN_CONFIG_FILES[@]}"; do
  backup_existing_file "$existing"
done

for dir in "${TARGET_DIRS[@]}"; do
  for file in "${FILES[@]}"; do
    install_file "$file" "$dir"
  done
done

echo ""
if [ -d "$BACKUP_ROOT" ]; then
  echo "Previous configs were backed up in: $BACKUP_ROOT"
else
  echo "No previous OpenCode config files found to back up."
fi

echo "Done. OpenCode configuration replaced."
