#!/usr/bin/env bash
# setup.sh - Bootstrap OpenCode configuration from remote (macOS / Linux)
# Run via: curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash

set -euo pipefail

BASE_URL="https://github.com/FRFlo/config-opencode/raw/refs/heads/develop"
TARGET_DIR="$HOME/.config/opencode"
FILES=("opencode.json" "oh-my-openagent.json")

mkdir -p "$TARGET_DIR"
echo "Target directory: $TARGET_DIR"

for file in "${FILES[@]}"; do
  url="$BASE_URL/$file"
  dest="$TARGET_DIR/$file"

  if [ -f "$dest" ]; then
    backup="${dest}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Existing config found: $file — backing up to $(basename "$backup")"
    mv "$dest" "$backup"
  fi

  echo "Downloading: $url"
  curl -fsSL "$url" -o "$dest"
  echo "  -> $dest"
done

echo ""
echo "Done. OpenCode configuration bootstrapped."