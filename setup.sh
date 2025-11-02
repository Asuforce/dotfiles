#!/bin/bash

set -euo pipefail

UNAME_MACHINE="$(/usr/bin/uname -m)"

if [[ "${UNAME_MACHINE}" == "arm64" ]]
then
  BREW_DIR="/opt/homebrew"
else
  BREW_DIR="/usr/local"
fi

readonly BREW=$BREW_DIR/bin/brew

# Create GITHUB_DIR
readonly GITHUB_DIR="$HOME/dev/src/github.com"
if [ ! -d "$GITHUB_DIR" ]; then
  mkdir -p "$GITHUB_DIR"
fi

# Install dotfiles
readonly REPO_DIR="$GITHUB_DIR/Asuforce/dotfiles"
[ ! -d "$REPO_DIR" ] && git clone https://github.com/Asuforce/dotfiles.git "$REPO_DIR"

# Install brew
if ! type "$BREW" > /dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install applications
"$BREW" bundle

# Install gh extensions
readonly GH="$BREW_DIR/bin/gh"
if type "$GH" > /dev/null 2>&1; then
  if ! "$GH" extension list | grep -q "seachicken/gh-poi"; then
    "$GH" extension install seachicken/gh-poi
  fi
fi

# Install rustup
if ! type rustup > /dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

# Link zsh config
readonly ZSH_CONFIG_FILES=(zshrc zshenv)
for file in "${ZSH_CONFIG_FILES[@]}"
do
  dest_file="$HOME/.$file"
  [ ! -e "$dest_file" ] && ln -fs "$REPO_DIR/zsh/$file" "$dest_file"
done

# Link tig config
readonly TIG_CONFIG_FILE="$HOME/.tigrc"
[ ! -e "$TIG_CONFIG_FILE" ] && ln -fs "$REPO_DIR/tig/tigrc" "$TIG_CONFIG_FILE"

# Link wezterm config
readonly WEZTERM_CONFIG_FILE="$HOME/.wezterm.lua"
[ ! -e "$WEZTERM_CONFIG_FILE" ] && ln -fs "$REPO_DIR/wezterm/wezterm.lua" "$WEZTERM_CONFIG_FILE"

# Link gitfiles
readonly GIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git"
[ ! -d "$GIT_DIR" ] && mkdir -p "$GIT_DIR"

readonly LINK_GIT_FILES=(config ignore)
for file in "${LINK_GIT_FILES[@]}"
do
  dest_file="$GIT_DIR/$file"
  [ ! -e "$dest_file" ] && ln -fs "$REPO_DIR/git/$file" "$dest_file"
done

readonly COPY_DOT_FILES=(.gitconfig .gitconfig-work)
for file in "${COPY_DOT_FILES[@]}"
do
  dest_file="$HOME/$file"
  [ ! -e "$dest_file" ] && cp "$REPO_DIR/git/$file" "$dest_file"
done

# Link Neovim config
readonly NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
[ ! -d "$NVIM_CONFIG_DIR" ] && mkdir -p "$NVIM_CONFIG_DIR"
readonly NVIM_CONFIG_FILE="$NVIM_CONFIG_DIR/init.lua"
[ ! -e "$NVIM_CONFIG_FILE" ] && ln -fs "$REPO_DIR/nvim/init.lua" "$NVIM_CONFIG_FILE"

# Setup sheldon
readonly SHELDON_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon"
[ ! -d "$SHELDON_CONFIG_DIR" ] && mkdir -p "$SHELDON_CONFIG_DIR"
readonly SHELDON_PLUGINS_FILE="$SHELDON_CONFIG_DIR/plugins.toml"
[ ! -e "$SHELDON_PLUGINS_FILE" ] && ln -fs "$REPO_DIR/sheldon/plugins.toml" "$SHELDON_PLUGINS_FILE"

# Set default shell
readonly ZSH_DIR="$BREW_DIR/bin/zsh"
readonly SHELL_FILE="/etc/shells"
if ! grep -q "$ZSH_DIR" "$SHELL_FILE"; then
  echo "$ZSH_DIR" | sudo tee -a "$SHELL_FILE" > /dev/null
fi

# Create ssh directory
readonly SSH_DIR="$HOME/.ssh"
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR/conf.d"
  chmod -R 700 "$SSH_DIR"
  cp "$REPO_DIR/ssh/config" "$SSH_DIR/config"
fi

# Link karabiner-elements config
readonly KARABINER_DIR="$HOME/.config/karabiner"
[ ! -d "$KARABINER_DIR" ] && mkdir -p "$KARABINER_DIR"
readonly KARABINER_CONFIG_FILE="$KARABINER_DIR/karabiner.json"
[ ! -e "$KARABINER_CONFIG_FILE" ] && ln -fs "$REPO_DIR/karabiner/karabiner.json" "$KARABINER_CONFIG_FILE"

# Link diff-highlight
readonly DIFF_HIGHLIGHT_FILE="$BREW_DIR/bin/diff-highlight"
[ ! -f "$DIFF_HIGHLIGHT_FILE" ] && ln -s "$BREW_DIR/share/git-core/contrib/diff-highlight/diff-highlight" "$DIFF_HIGHLIGHT_FILE"

# Install tpm
readonly TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  mkdir -p "$TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm.git "$TPM_DIR"
fi

# Link Hammerspoon config
readonly HAMMERSPOON_DIR="$HOME/.hammerspoon"
[ ! -d "$HAMMERSPOON_DIR" ] && mkdir "$HAMMERSPOON_DIR"
readonly HAMMERSPOON_FILE="$HAMMERSPOON_DIR/init.lua"
[ ! -f "$HAMMERSPOON_FILE" ] && ln -s "$REPO_DIR/hammerspoon/init.lua" "$HAMMERSPOON_FILE"

# Link Claude Code config
readonly CLAUDE_CONFIG_DIR="$HOME/.claude"
[ ! -d "$CLAUDE_CONFIG_DIR" ] && mkdir -p "$CLAUDE_CONFIG_DIR"

readonly DOTFILES_LLM="$REPO_DIR/llm"
readonly CLAUDE_AGENTS_FILE="$CLAUDE_CONFIG_DIR/CLAUDE.md"
[ ! -e "$CLAUDE_AGENTS_FILE" ] && ln -fs "$DOTFILES_LLM/AGENTS.md" "$CLAUDE_AGENTS_FILE"

readonly CLAUDE_SETTINGS_FILE="$CLAUDE_CONFIG_DIR/settings.json"
[ ! -e "$CLAUDE_SETTINGS_FILE" ] && ln -fs "$DOTFILES_LLM/settings.json" "$CLAUDE_SETTINGS_FILE"

readonly CLAUDE_COMMANDS_DIR="$CLAUDE_CONFIG_DIR/commands"
[ ! -e "$CLAUDE_COMMANDS_DIR" ] && ln -fs "$DOTFILES_LLM/commands" "$CLAUDE_COMMANDS_DIR"

# Restart shell
exec "$SHELL" -l
