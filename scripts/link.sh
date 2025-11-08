#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

UNAME_MACHINE="$(/usr/bin/uname -m)"

if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
  BREW_DIR="/opt/homebrew"
else
  BREW_DIR="/usr/local"
fi

# Link zsh config
printf "Linking Zsh config files...\n"
readonly ZSH_CONFIG_FILES=(zshrc zshenv)
for file in "${ZSH_CONFIG_FILES[@]}"; do
  dest_file="$HOME/.$file"
  [ ! -e "$dest_file" ] && ln -fs "$REPO_DIR/config/zsh/$file" "$dest_file"
done

# Link tig config
printf "Linking Tig config...\n"
readonly TIG_CONFIG_FILE="$HOME/.tigrc"
[ ! -e "$TIG_CONFIG_FILE" ] && ln -fs "$REPO_DIR/config/tig/tigrc" "$TIG_CONFIG_FILE"

# Link wezterm config
printf "Linking Wezterm config...\n"
readonly WEZTERM_CONFIG_FILE="$HOME/.wezterm.lua"
[ ! -e "$WEZTERM_CONFIG_FILE" ] && ln -fs "$REPO_DIR/config/wezterm/wezterm.lua" "$WEZTERM_CONFIG_FILE"

# Link git config files
printf "Linking Git config files...\n"
readonly GIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git"
[ ! -d "$GIT_DIR" ] && mkdir -p "$GIT_DIR"

readonly LINK_GIT_FILES=(config ignore)
for file in "${LINK_GIT_FILES[@]}"; do
  dest_file="$GIT_DIR/$file"
  [ ! -e "$dest_file" ] && ln -fs "$REPO_DIR/config/git/$file" "$dest_file"
done

# Copy git user config files (not symlinked)
readonly COPY_DOT_FILES=(.gitconfig .gitconfig-work)
for file in "${COPY_DOT_FILES[@]}"; do
  dest_file="$HOME/$file"
  [ ! -e "$dest_file" ] && cp "$REPO_DIR/config/git/$file" "$dest_file"
done

# Link Neovim config
printf "Linking Neovim config...\n"
readonly NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
[ ! -d "$NVIM_CONFIG_DIR" ] && mkdir -p "$NVIM_CONFIG_DIR"
readonly NVIM_CONFIG_FILE="$NVIM_CONFIG_DIR/init.lua"
[ ! -e "$NVIM_CONFIG_FILE" ] && ln -fs "$REPO_DIR/config/nvim/init.lua" "$NVIM_CONFIG_FILE"

# Link Sheldon config
printf "Linking Sheldon config...\n"
readonly SHELDON_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon"
[ ! -d "$SHELDON_CONFIG_DIR" ] && mkdir -p "$SHELDON_CONFIG_DIR"
readonly SHELDON_PLUGINS_FILE="$SHELDON_CONFIG_DIR/plugins.toml"
[ ! -e "$SHELDON_PLUGINS_FILE" ] && ln -fs "$REPO_DIR/config/sheldon/plugins.toml" "$SHELDON_PLUGINS_FILE"

# Link Starship config
printf "Linking Starship config...\n"
readonly STARSHIP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"
[ ! -e "$STARSHIP_CONFIG_FILE" ] && ln -fs "$REPO_DIR/config/starship/starship.toml" "$STARSHIP_CONFIG_FILE"

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
readonly KARABINER_DIR="$HOME/.config/karabiner"
[ ! -d "$KARABINER_DIR" ] && mkdir -p "$KARABINER_DIR"
readonly KARABINER_CONFIG_FILE="$KARABINER_DIR/karabiner.json"
[ ! -e "$KARABINER_CONFIG_FILE" ] && ln -fs "$REPO_DIR/config/karabiner/karabiner.json" "$KARABINER_CONFIG_FILE"

# Link diff-highlight
printf "Linking diff-highlight...\n"
readonly DIFF_HIGHLIGHT_FILE="$BREW_DIR/bin/diff-highlight"
[ ! -f "$DIFF_HIGHLIGHT_FILE" ] && ln -s "$BREW_DIR/share/git-core/contrib/diff-highlight/diff-highlight" "$DIFF_HIGHLIGHT_FILE"

# Link Hammerspoon config
printf "Linking Hammerspoon config...\n"
readonly HAMMERSPOON_DIR="$HOME/.hammerspoon"
[ ! -d "$HAMMERSPOON_DIR" ] && mkdir "$HAMMERSPOON_DIR"
readonly HAMMERSPOON_FILE="$HAMMERSPOON_DIR/init.lua"
[ ! -f "$HAMMERSPOON_FILE" ] && ln -s "$REPO_DIR/config/hammerspoon/init.lua" "$HAMMERSPOON_FILE"

# Link bat config
printf "Linking bat config...\n"
readonly BAT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/bat"
[ ! -d "$BAT_CONFIG_DIR" ] && mkdir -p "$BAT_CONFIG_DIR"
readonly BAT_CONFIG_FILE="$BAT_CONFIG_DIR/config"
[ ! -e "$BAT_CONFIG_FILE" ] && ln -fs "$REPO_DIR/config/bat/config" "$BAT_CONFIG_FILE"

printf "All symlinks created successfully.\n"
