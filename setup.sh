#!/usr/bin/env bash
set -euo pipefail

repo_root="https://github.com/FRFlo/config-opencode/raw/refs/heads/develop"
target_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
files=("opencode.json" "oh-my-openagent.json")
valid_flavors=("cheap" "perf")
flavor="${1:-${OPENCODE_PROFILE:-}}"

is_valid_flavor() {
  local candidate="$1"
  for item in "${valid_flavors[@]}"; do
    if [[ "$candidate" == "$item" ]]; then
      return 0
    fi
  done
  return 1
}

resolve_flavor() {
  local requested="$1"
  if is_valid_flavor "$requested"; then
    printf '%s\n' "$requested"
    return 0
  fi

  echo "Select the OpenCode profile to install:"
  echo "  1) cheap  - OpenCode Go + OpenAI"
  echo "  2) perf   - OpenAI only"
  while true; do
    read -r -p "Enter 1 or 2 (default: 1): " choice || true
    case "${choice:-1}" in
      1)
        printf '%s\n' "cheap"
        return 0
        ;;
      2)
        printf '%s\n' "perf"
        return 0
        ;;
      *)
        echo "Invalid selection. Please choose 1 or 2."
        ;;
    esac
  done
}

flavor="$(resolve_flavor "$flavor")"

mkdir -p "$target_dir"
echo "Installing profile: $flavor"

for file in "${files[@]}"; do
  url="$repo_root/$flavor/$file"
  destination="$target_dir/$file"
  echo "Downloading: $url"
  curl -fsSL "$url" -o "$destination"
  echo "  -> $destination"
done

echo
echo "Done. OpenCode configuration bootstrapped with '$flavor'."
