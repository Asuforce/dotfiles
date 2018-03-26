#!/bin/bash

# create GITHUB_DIR
readonly GITHUB_DIR="$HOME/local/src/github.com"

if [ ! -d $GITHUB_DIR  ]; then
  mkdir -p $GITHUB_DIR
fi

# install dotfiles
readonly REPO_DIR="$GITHUB_DIR/Asuforce/dotfiles"
if [ ! -d $REPO_DIR ]; then
  git clone https://github.com/Asuforce/dotfiles.git $REPO_DIR
fi

# install brew and package
if [ ! $commands[brew] ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install mkr
if [ ! -d "/usr/local/Cellar/mkr" ]; then
  brew tap mackerelio/mackerel-agent
  brew install mkr
fi

# install packges
while read pkg
do
  if [ ! -d "/usr/local/Cellar/$pkg" ]; then
    brew install $pkg
  fi
done < $REPO_DIR/brew.txt

# link dotfiles
readonly DOT_FILES=(.gitconfig .gitconfig-work .gitignore .gitmodules .vimrc .tmux.conf .zshrc .zshenv)
readonly DEIN_FILES=(dein.toml dein_lazy.toml)

for file in ${DOT_FILES[@]}
do
  dest_file="$HOME/$file"
  if [ -e $dest_file ]; then
    ln -fs $REPO_DIR/$file $dest_file
  fi
done

for file in ${DEIN_FILES[@]}
do
  dest_file="$HOME/.vim/dein/$file"
  if [ -e $dest_file ]; then
    ln -fs $REPO_DIR/.vim/dein/$file $dest_file
  fi
done

# install zgen
readonly ZGEN_DIR="$HOME/.zgen"
if [ ! -d $ZGEN_DIR ]; then
  git clone https://github.com/tarjoilija/zgen.git $ZGEN_DIR
fi

# install anyenv
if [ ! -d ~/.anyenv ]; then
  git clone https://github.com/riywo/anyenv ~/.anyenv

  mkdir ~/.anyenv/plugins
  git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

  exec -l $SHELL

  anyenv install rbenv
  anyenv install goenv
fi

# create ssh directory
if [ ! -d ~/.ssh  ]; then
  mkdir -p ~/.ssh/conf.d
fi

# restart shell
exec -l $SHELL
