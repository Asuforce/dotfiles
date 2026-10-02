#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

readonly SRC="$REPO_DIR/config/home-server"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly USER_NAME="$(id -un)"

system_changed=0

# @USER@ is rendered per machine, so the file is compared after rendering.
install_system() {
  local src="$1" dest="$2" mode="$3" tmp
  tmp="$(mktemp)"
  sed "s/@USER@/$USER_NAME/g" "$src" >"$tmp"
  if ! cmp -s "$tmp" "$dest"; then
    sudo install -Dm"$mode" "$tmp" "$dest"
    system_changed=1
  fi
  rm -f "$tmp"
}

# The repo owns these, so a copy left by an earlier manual install is replaced.
link_user() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
}

# logind reads this at start-up only; reboot or restart systemd-logind to apply.
printf "Ignoring the lid switch...\n"
install_system "$SRC/30-lid-ignore.conf" /etc/systemd/logind.conf.d/30-lid-ignore.conf 644

printf "Setting up the nightly suspend...\n"
install_system "$SRC/mf-nightly-sleep" /usr/local/bin/mf-nightly-sleep 755
install_system "$SRC/stay-awake" /usr/local/bin/stay-awake 755
install_system "$SRC/mf-nightly-sleep.service" /etc/systemd/system/mf-nightly-sleep.service 644
install_system "$SRC/mf-nightly-sleep.timer" /etc/systemd/system/mf-nightly-sleep.timer 644
if ((system_changed)); then
  sudo systemctl daemon-reload
  sudo systemctl restart mf-nightly-sleep.timer 2>/dev/null || true
fi
sudo systemctl enable --now mf-nightly-sleep.timer

printf "Setting up the go-to-bed reminder...\n"
link_user "$SRC/go-to-bed-notice" "$HOME/.local/bin/go-to-bed-notice"
link_user "$SRC/clawd-go-to-bed" "$HOME/.local/bin/clawd-go-to-bed"
link_user "$SRC/clawd.png" "$HOME/.local/share/go-to-bed/clawd.png"
link_user "$SRC/clawd.svg" "$HOME/.local/share/go-to-bed/clawd.svg"
link_user "$SRC/go-to-bed-notice.service" "$CONFIG_HOME/systemd/user/go-to-bed-notice.service"
link_user "$SRC/go-to-bed-notice.timer" "$CONFIG_HOME/systemd/user/go-to-bed-notice.timer"
systemctl --user daemon-reload
systemctl --user enable --now go-to-bed-notice.timer

# omarchy seeds bindings.lua, so a marked block is appended rather than the file replaced.
printf "Blanking the panel on lid close...\n"
readonly HYPR_BINDINGS="$CONFIG_HOME/hypr/bindings.lua"
readonly HYPR_MARKER="-- dotfiles: blank the panel while the lid is closed"
if [ ! -f "$HYPR_BINDINGS" ] || ! grep -qF -- "$HYPR_MARKER" "$HYPR_BINDINGS"; then
  mkdir -p "$(dirname "$HYPR_BINDINGS")"
  { printf "\n"; cat "$SRC/hypr-lid-dpms.lua"; } >>"$HYPR_BINDINGS"
  command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
fi
