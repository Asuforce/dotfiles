#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

readonly LIST="$REPO_DIR/config/packages/linux.txt"

# omarchy pkg add is a thin pacman -S --needed wrapper. The AUR is not used, so
# every entry in the list is an `official` one. It does not touch a path omarchy owns.
official=()
while read -r source name _; do
  case "$source" in
    ''|\#*) ;;
    official) official+=("$name") ;;
    *) printf "Unknown source '%s' in %s\n" "$source" "$LIST" >&2; exit 1 ;;
  esac
done <"$LIST"

if ((${#official[@]})); then
  printf "Installing official packages...\n"
  omarchy pkg add "${official[@]}"
fi

# HackGen is not in any repository omarchy uses, so it comes from the upstream
# release. Ghostty needs HackGen35 / HackGen35 Console and the system monospace
# font is HackGen35 Console NF, hence both the plain and the NF archives.
readonly HACKGEN_VERSION="v2.10.0"
readonly FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/HackGen"
if ! fc-list | grep -qF "HackGen35 Console NF"; then
  printf "Installing HackGen %s...\n" "$HACKGEN_VERSION"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  mkdir -p "$FONT_DIR"
  for archive in HackGen HackGen_NF; do
    curl -fsSL -o "$tmp/$archive.zip" \
      "https://github.com/yuru7/HackGen/releases/download/$HACKGEN_VERSION/${archive}_$HACKGEN_VERSION.zip"
    unzip -qjo "$tmp/$archive.zip" '*.ttf' -d "$FONT_DIR"
  done
  fc-cache -f "$FONT_DIR"
fi
