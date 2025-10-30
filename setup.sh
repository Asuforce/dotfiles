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

# Install rust packages
while read -r pkg opt
do
  if [ ! -e "$HOME/.cargo/bin/$opt" ]; then
    "$HOME/.cargo/bin/cargo" install "$pkg"
  fi
done < "$REPO_DIR/cargo.txt"

# Setup dotfiles
readonly LINK_DOT_FILES=(tmux.conf vimrc zshrc zshenv tigrc)
for file in "${LINK_DOT_FILES[@]}"
do
  dest_file="$HOME/.$file"
  [ ! -e "$dest_file" ] && ln -fs "$REPO_DIR/.$file" "$dest_file"
done

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

# Link dein files
readonly DEIN_DIR="$HOME/.vim/dein"
[ ! -d "$DEIN_DIR" ] && mkdir -p "$DEIN_DIR"

readonly DEIN_FILES=(dein.toml dein_lazy.toml)
for file in "${DEIN_FILES[@]}"
do
  dest_file="$DEIN_DIR/$file"
  [ ! -e "$dest_file" ] && ln -fs "$REPO_DIR/$file" "$dest_file"
done

# Install zgen
readonly ZGEN_DIR="$HOME/.zgen"
[ ! -d "$ZGEN_DIR" ] && git clone https://github.com/tarjoilija/zgen.git "$ZGEN_DIR"

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
  cp "$REPO_DIR/ssh_config" "$SSH_DIR/ssh_config"
  cp "$REPO_DIR/config" "$SSH_DIR/config"
fi

# Link karabiner-elements config
readonly KARABINER_DIR="$HOME/.config/karabiner"
[ ! -d "$KARABINER_DIR" ] && ln -fs "$REPO_DIR/karabiner" "$KARABINER_DIR"

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
[ ! -f "$HAMMERSPOON_FILE" ] && ln -s "$REPO_DIR/init.lua" "$HAMMERSPOON_FILE"


# Restart shell
exec "$SHELL" -l
