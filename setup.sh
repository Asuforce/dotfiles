#!/bin/bash

# create GITHUB_DIR
readonly GITHUB_DIR="$GOPATH/src/github.com"

if [ ! -d $GITHUB_DIR  ]; then
  mkdir $GITHUB_DIR
fi

# install dotfiles
readonly REPO_DIR="$GITHUB_DIR/Asuforce/dotfiles"
if [ ! -d $REPO_DIR ]; then
  git clone https://github.com/Asuforce/dotfiles.git $REPO_DIR
fi

# install brew and package
if [ ! -e /usr/local/bin/brew ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  cat $REPO_DIR/brew.txt | xargs brew install
  brew tap mackerelio/mackerel-agent
  brew install mkr
fi

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

# install prezto
if [ ! -d ~/.zprezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
fi

# install z
if [ ! -d ~/.z_lib ]; then
  git clone git://github.com/rupa/z ~/.z_lib
fi

# install anyenv
if [ ! -d ~/.anyenv ]; then
  git clone https://github.com/riywo/anyenv ~/.anyenv
fi

# create ssh directory
if [ ! -d ~/.ssh  ]; then
  mkdir ~/.ssh/conf.d
fi

# restart shell
exec -l $SHELL
