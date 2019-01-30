#!/bin/sh

set -eu

# Create GITHUB_DIR
readonly GITHUB_DIR="$HOME/dev/src/github.com"

if [ ! -d $GITHUB_DIR  ]; then
  mkdir -p $GITHUB_DIR
fi

# Install dotfiles
readonly REPO_DIR="$GITHUB_DIR/Asuforce/dotfiles"
if [ ! -d $REPO_DIR ]; then
  git clone https://github.com/Asuforce/dotfiles.git $REPO_DIR
fi

# Install brew
if ! type brew > /dev/null 2>&1; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install applications
while read pkg
do
  if [ ! -d "/usr/local/Caskroom/$pkg" ]; then
    if [ "$pkg" == "java8" ]; then
      brew tap caskroom/versions
    elif [ "$pkg" == "font-ricty-diminished" ]; then
      brew tap caskroom/fonts
    fi

    brew cask install $pkg
  fi
done < $REPO_DIR/brew_cask.txt

# Install packges
while read pkg opt
do
  if [ ! -d "/usr/local/Cellar/$pkg" ]; then
    if [ $pkg == "draft" ]; then
      brew tap azure/draft
    fi
    brew install $pkg $opt
  fi
done < $REPO_DIR/brew.txt

# Install rustup
if ! type rustup > /dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh
fi

# Install rust packages
while read pkg opt
do
  if [ ! -e "$HOME/.cargo/bin/$opt" ]; then
    cargo install $pkg
  fi
done < $REPO_DIR/cargo.txt

# Setup dotfiles
readonly LINK_DOT_FILES=(gitconfig gitignore tmux.conf vimrc  zshrc zshenv tigrc)
for file in ${LINK_DOT_FILES[@]}
do
  dest_file="$HOME/.$file"
  if [ ! -e $dest_file ]; then
    ln -fs $REPO_DIR/.$file $dest_file
  fi
done

readonly COPY_DOT_FILES=(gitconfig-user gitconfig-work netrc)
for file in ${COPY_DOT_FILES[@]}
do
  dest_file="$HOME/.$file"
  if [ ! -e $dest_file ]; then
    cp $REPO_DIR/.$file $dest_file
  fi
done

# Link dein files
readonly DEIN_DIR="$HOME/.vim/dein"
if [ ! -e $DEIN_DIR ]; then
  mkdir -p $DEIN_DIR

  readonly DEIN_FILES=(dein.toml dein_lazy.toml)
  for file in ${DEIN_FILES[@]}
  do
    dest_file="$DEIN_DIR/$file"
    if [ ! -e $dest_file ]; then
      ln -fs $REPO_DIR/$file $dest_file
    fi
  done
fi

# Install zgen
readonly ZGEN_DIR="$HOME/.zgen"
if [ ! -d $ZGEN_DIR ]; then
  git clone https://github.com/tarjoilija/zgen.git $ZGEN_DIR
fi

# Install anyenv
readonly ANYENV_DIR="$HOME/.anyenv"
if [ ! -d $ANYENV_DIR ]; then
  git clone https://github.com/riywo/anyenv $ANYENV_DIR
fi

# Set default shell
readonly ZSH_DIR="/usr/local/bin/zsh"
readonly SHELL_FILE="/etc/shells"
if ! grep $ZSH_DIR $SHELL_FILE > /dev/null; then
  echo $ZSH_DIR | sudo tee -a $SHELL_FILE
fi

# Create ssh directory
readonly SSH_DIR="$HOME/.ssh"
if [ ! -d $SSH_DIR  ]; then
  mkdir -p $SSH_DIR/conf.d
  chmod -R 700 $SSH_DIR
  cp $REPO_DIR/.ssh_config $SSH_DIR/ssh_config
  cp $REPO_DIR/.config $SSH_DIR/config
fi

# Link karabiner-elements config
readonly DROPBOX_DIR="$HOME/Dropbox/Apps/karabiner"
if [ ! -d $DROPBOX_DIR ]; then
  mkdir -p $DROPBOX_DIR
fi

readonly KARABINER_DIR="$HOME/.config/karabiner"
if [ ! -d $KARABINER_DIR ]; then
  ln -fs $DROPBOX_DIR $KARABINER_DIR
fi

# Restart shell
exec -l $SHELL
