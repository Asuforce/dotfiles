#!/bin/bash
REPO_PATH="$HOME/local/src/github.com/Asuforce/dotfiles"

DOT_FILES=(.gitconfig .gitconfig-work .gitignore .gitmodules .vimrc .tmux.conf .zshrc .zshenv)
DEIN_FILES=(dein.toml dein_lazy.toml)

for file in ${DOT_FILES[@]}
do
    ln -fs $REPO_PATH/$file $HOME/$file
done

for file in ${DEIN_FILES[@]}
do
    ln -fs $REPO_PATH/.vim/dein/$file $HOME/.vim/dein/$file
done

# install prezto
[ ! -d ~/.zprezto ] && git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

# install z
[ ! -d ~/.z_lib  ] && git clone git://github.com/rupa/z ~/.z_lib

# install anyenv
[ ! -d ~/.anyenv  ] && git clone https://github.com/riywo/anyenv ~/.anyenv

# create ssh directory
[ ! -d ~/.ssh  ] && mkdir ~/.ssh/conf.d

# install brew and package
if [ ! -e /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  cat brew.txt | xargs brew install
fi

# install mkr
if [ ! -e /usr/local/bin/mkr ] ; then
  brew tap mackerelio/mackerel-agent
  brew install mkr
fi

# restart shell
exec -l $SHELL
