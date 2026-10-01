#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

readonly LIST="$REPO_DIR/config/packages/linux.txt"

# omarchy pkg add is a thin pacman -S --needed wrapper and cannot install AUR
# packages, so those go through yay directly. Neither touches a path omarchy owns.
official=()
aur=()
while read -r source name _; do
  case "$source" in
    ''|\#*) ;;
    official) official+=("$name") ;;
    aur) aur+=("$name") ;;
    *) printf "Unknown source '%s' in %s\n" "$source" "$LIST" >&2; exit 1 ;;
  esac
done <"$LIST"

if ((${#official[@]})); then
  printf "Installing official packages...\n"
  omarchy pkg add "${official[@]}"
fi

if ((${#aur[@]})); then
  printf "Installing AUR packages...\n"
  yay -S --needed --noconfirm "${aur[@]}"
fi
