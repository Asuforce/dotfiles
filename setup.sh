#!/bin/sh

set -eu

readonly OS=$(uname)

if [ "$OS" == "Darwin" ]; then
  readonly BREW_DIR=/usr/local
else
  readonly BREW_DIR=/home/linuxbrew/.linuxbrew
fi

readonly BREW=$BREW_DIR/bin/brew

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
if ! type $BREW > /dev/null 2>&1; then
  if [ "$OS" == "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  fi
fi

# Install applications
if [ "$OS" == "Darwin" ]; then
  while read pkg
  do
    format_pkg="$(echo $pkg | rev | cut -d '/' -f 1 | rev)"
    if [ ! -d "$BREW_DIR/Caskroom/$format_pkg" ]; then
      $BREW cask install $pkg
    fi
  done < $REPO_DIR/brew_cask.txt
fi

# Install packges
while read pkg opt
do
  format_pkg="$(echo $pkg | rev | cut -d '/' -f 1 | rev)"
  if [ ! -d "$BREW_DIR/Cellar/$format_pkg" ]; then
    $BREW install $pkg $opt
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
readonly ZSH_DIR="$BREW_DIR/bin/zsh"
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

# Link diff-highlight
readonly DIFF_HIGHLIGHT_FILE=$BREW_DIR/bin/diff-highlight
if [ ! -f $DIFF_HIGHLIGHT_FILE ]; then
  ln -s $BREW_DIR/share/git-core/contrib/diff-highlight/diff-highlight $DIFF_HIGHLIGHT_FILE
fi

# Restart shell
exec -l $SHELL
