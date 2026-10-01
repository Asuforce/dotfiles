#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

readonly OS="$(uname -s)"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Never replaces an existing path. An existing path that is not already this
# link is reported: on omarchy the distro seeds some of these files first, and a
# silent skip would leave the repo's version unapplied without any sign of it.
link_config() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    ln -s "$src" "$dest"
  elif [ "$(readlink "$dest" 2>/dev/null || true)" != "$src" ]; then
    printf "  skipped, already exists: %s\n" "$dest"
  fi
}

# Link zsh config
printf "Linking Zsh config files...\n"
link_config "$REPO_DIR/config/zsh/zshrc" "$HOME/.zshrc"

# Link tig config
printf "Linking Tig config...\n"
link_config "$REPO_DIR/config/tig/tigrc" "$HOME/.tigrc"

# Link Sheldon config
printf "Linking Sheldon config...\n"
link_config "$REPO_DIR/config/sheldon/plugins.toml" "$CONFIG_HOME/sheldon/plugins.toml"

# Link bat config
printf "Linking bat config...\n"
link_config "$REPO_DIR/config/bat/config" "$CONFIG_HOME/bat/config"

# Link zsh-abbr abbreviations
printf "Linking zsh-abbr abbreviations...\n"
link_config "$REPO_DIR/config/zsh/abbreviations" "$CONFIG_HOME/zsh-abbr/abbreviations"

if [[ "$OS" == "Darwin" ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_DIR="/opt/homebrew"
  else
    BREW_DIR="/usr/local"
  fi

  # Link Ghostty config
  printf "Linking Ghostty config...\n"
  link_config "$REPO_DIR/config/ghostty/config.ghostty" "$CONFIG_HOME/ghostty/config.ghostty"

  # Link herdr config
  printf "Linking herdr config...\n"
  link_config "$REPO_DIR/config/herdr/config.toml" "$CONFIG_HOME/herdr/config.toml"

  # Link git config files
  printf "Linking Git config files...\n"
  readonly LINK_GIT_FILES=(config ignore)
  for file in "${LINK_GIT_FILES[@]}"; do
    link_config "$REPO_DIR/config/git/$file" "$CONFIG_HOME/git/$file"
  done

  # Copy git user config files (not symlinked)
  readonly COPY_DOT_FILES=(.gitconfig .gitconfig-work)
  for file in "${COPY_DOT_FILES[@]}"; do
    dest_file="$HOME/$file"
    [ ! -e "$dest_file" ] && cp "$REPO_DIR/config/git/$file" "$dest_file"
  done

  # Copy zsh work config (not symlinked, not git-managed)
  readonly ZSHRC_WORK="$HOME/.zshrc.work"
  [ ! -e "$ZSHRC_WORK" ] && cp "$REPO_DIR/config/zsh/zshrc.work" "$ZSHRC_WORK"

  # Link Neovim config
  printf "Linking Neovim config...\n"
  link_config "$REPO_DIR/config/nvim/init.lua" "$CONFIG_HOME/nvim/init.lua"

  # Link Starship config
  printf "Linking Starship config...\n"
  link_config "$REPO_DIR/config/starship/starship.toml" "$CONFIG_HOME/starship.toml"

  # Link btop config
  printf "Linking btop config...\n"
  link_config "$REPO_DIR/config/btop/btop.conf" "$CONFIG_HOME/btop/btop.conf"

  # Set default shell to Zsh
  printf "Setting default shell to Zsh...\n"
  readonly ZSH_DIR="$BREW_DIR/bin/zsh"
  readonly SHELL_FILE="/etc/shells"
  if ! grep -q "$ZSH_DIR" "$SHELL_FILE"; then
    echo "$ZSH_DIR" | sudo tee -a "$SHELL_FILE" > /dev/null
  fi

  # Create SSH directory and copy config
  printf "Setting up SSH directory...\n"
  readonly SSH_DIR="$HOME/.ssh"
  if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR/conf.d"
    chmod -R 700 "$SSH_DIR"
    cp "$REPO_DIR/config/ssh/config" "$SSH_DIR/config"
  fi

  # Link Karabiner config
  printf "Linking Karabiner config...\n"
  link_config "$REPO_DIR/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

  # Link diff-highlight
  printf "Linking diff-highlight...\n"
  readonly DIFF_HIGHLIGHT_FILE="$BREW_DIR/bin/diff-highlight"
  [ ! -f "$DIFF_HIGHLIGHT_FILE" ] && ln -s "$BREW_DIR/share/git-core/contrib/diff-highlight/diff-highlight" "$DIFF_HIGHLIGHT_FILE"

  # Link Hammerspoon config
  printf "Linking Hammerspoon config...\n"
  link_config "$REPO_DIR/config/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"
else
  # keyd reads only /etc/keyd, so the file is copied there rather than linked.
  # keyd is in config/packages/linux.txt; the guard below only covers running
  # `make link` on its own.
  printf "Setting up keyd...\n"
  readonly KEYD_SRC="$REPO_DIR/config/keyd/default.conf"
  readonly KEYD_DEST="/etc/keyd/default.conf"
  if ! command -v keyd >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm keyd
  fi
  if ! cmp -s "$KEYD_SRC" "$KEYD_DEST"; then
    sudo install -Dm644 "$KEYD_SRC" "$KEYD_DEST"
  fi
  sudo systemctl enable --now keyd
  sudo keyd reload

  # omarchy seeds these two files, so link_config would skip them. A marked
  # block is appended instead, and a file that already carries the setting is
  # reported and left alone.
  # ctrl:nocaps puts Control on Caps Lock; dropping omarchy's compose:caps is
  # what lets that take effect, and Compose sequences are not used here.
  printf "Applying Hyprland keyboard options...\n"
  readonly HYPR_INPUT="$CONFIG_HOME/hypr/input.lua"
  readonly HYPR_INPUT_MARKER="-- dotfiles: Caps Lock is Control"
  if [ ! -f "$HYPR_INPUT" ] || ! grep -qF -- "$HYPR_INPUT_MARKER" "$HYPR_INPUT"; then
    mkdir -p "$(dirname "$HYPR_INPUT")"
    cat >>"$HYPR_INPUT" <<EOF

$HYPR_INPUT_MARKER
hl.config({ input = { kb_options = "ctrl:nocaps,shift:both_capslock_cancel" } })
EOF
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
  fi

  # keyd sends Muhenkan/Henkan on a lone left/right command tap; fcitx5 turns
  # them into off/on. fcitx5 seeds the file with these sections commented out.
  printf "Binding Muhenkan/Henkan in fcitx5...\n"
  readonly FCITX5_CONFIG="$CONFIG_HOME/fcitx5/config"
  readonly FCITX5_MARKER="# dotfiles: Muhenkan/Henkan switch the input method"
  if [ -f "$FCITX5_CONFIG" ] && grep -qE '^\[Hotkey/(Activate|Deactivate)Keys\]' "$FCITX5_CONFIG" \
    && ! grep -qF "$FCITX5_MARKER" "$FCITX5_CONFIG"; then
    printf "  skipped, already set: %s\n" "$FCITX5_CONFIG"
  elif [ ! -f "$FCITX5_CONFIG" ] || ! grep -qF "$FCITX5_MARKER" "$FCITX5_CONFIG"; then
    mkdir -p "$(dirname "$FCITX5_CONFIG")"
    cat >>"$FCITX5_CONFIG" <<EOF

$FCITX5_MARKER
[Hotkey/ActivateKeys]
0=Henkan

[Hotkey/DeactivateKeys]
0=Muhenkan
EOF
    command -v fcitx5-remote >/dev/null 2>&1 && fcitx5-remote -r >/dev/null 2>&1 || true
  fi

  # omarchy owns the login shell and seeds ~/.bashrc, so zsh is entered from
  # there rather than through chsh or a replaced ~/.bashrc. Interactive-only:
  # Claude Code snapshots ~/.bashrc non-interactively, and an exec there would
  # replace that shell. exec keeps the variables omarchy's bash already exported.
  printf "Handing interactive bash over to zsh...\n"
  readonly BASHRC="$HOME/.bashrc"
  readonly BASHRC_MARKER="# dotfiles: hand interactive shells over to zsh"
  if [ ! -f "$BASHRC" ] || ! grep -qF "$BASHRC_MARKER" "$BASHRC"; then
    cat >>"$BASHRC" <<EOF

$BASHRC_MARKER
if [[ \$- == *i* ]] && [[ -z \${ZSH_VERSION:-} ]] && command -v zsh >/dev/null 2>&1; then
  exec zsh
fi
EOF
  fi
fi

printf "All symlinks created successfully.\n"
