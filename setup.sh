#!/bin/bash
DOT_FILES=( .zshrc .gitconfig .gitignore .vimrc .tmux.conf)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done

# install oh-my-zsh
[ ! -d ~/.oh-my-zsh ] && git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# install z
[ ! -d ~/.z_lib  ] && git clone git://github.com/rupa/z ~/.z_lib

# sshフォルダ作成
mkdir ~/.ssh

# brew導入
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 各ソフト導入
brew install zsh
brew install tmux
brew install vim
brew install git
brew install peco
brew install tig
brew install go

# シェルを再起動
exec -l $SHELL

