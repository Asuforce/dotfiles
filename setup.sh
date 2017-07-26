#!/bin/bash
DOT_FILES=(.gitconfig .gitconfig-work .gitignore .gitmodules .vimrc .tmux.conf .zshrc)

for file in ${DOT_FILES[@]}
do
    ln -fs $HOME/workspace/github.com/Asuforce/dotfiles/$file $HOME/$file
done

# install prezto
[ ! -d ~/.zprezto ] && git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto

# install z
[ ! -d ~/.z_lib  ] && git clone git://github.com/rupa/z ~/.z_lib

# create ssh directory
mkdir ~/.ssh

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# add package from brew
cat brew.txt | xargs brew install

# restart shell
exec -l $SHELL
