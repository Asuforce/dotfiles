#!/bin/sh

# create GITHUB_DIR
readonly GITHUB_DIR="$HOME/dev/src/github.com"

if [ ! -d $GITHUB_DIR  ]; then
  mkdir -p $GITHUB_DIR
fi

# install dotfiles
readonly REPO_DIR="$GITHUB_DIR/Asuforce/dotfiles"
if [ ! -d $REPO_DIR ]; then
  git clone https://github.com/Asuforce/dotfiles.git $REPO_DIR
fi

# install brew
if ! type brew > /dev/null 2>&1; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install packges
while read pkg opt
do
  if [ ! -d "/usr/local/Cellar/$pkg" ]; then
    if [ $pkg == "mkr" ]; then
      brew tap mackerelio/mackerel-agent
    fi

    brew install $pkg $opt
  fi
done < $REPO_DIR/brew.txt

# install applications
while read name
do
  check_dir="/Applications/$name.app"
  if [ "$name" = "Java" ]; then
    check_dir="/Library/Java/Home"
  fi

  case $name in
    Alfred* ) app="alfred" ;;
    "Last.fm" ) app="lastfm" ;;
    * ) app="$(echo $name | sed -e "s/ /-/g")" ;;
  esac

  if [ ! -d "$check_dir" ]; then
    brew cask install $app
  fi
done < $REPO_DIR/app.txt

# link dotfiles
readonly DOT_FILES=(.gitconfig .gitignore .vimrc .tmux.conf .zshrc .zshenv)
for file in ${DOT_FILES[@]}
do
  dest_file="$HOME/$file"
  if [ ! -e $dest_file ]; then
    ln -fs $REPO_DIR/$file $dest_file
  fi
done

if [ ! -e "$HOME/.gitconfig-work" ]; then
  cp $REPO_DIR/.gitconfig-work $HOME
fi

if [ ! -e "$HOME/.netrc" ]; then
  cp $REPO_DIR/.netrc $HOME
fi

# link dein files
readonly DEIN_DIR="$HOME/.vim/dein"
if [ ! -e $DEIN_DIR ]; then
  mkdir -p $DEIN_DIR

  readonly DEIN_FILES=(dein.toml dein_lazy.toml)
  for file in ${DEIN_FILES[@]}
  do
    dest_file="$HOME/.vim/dein/$file"
    if [ ! -e $dest_file ]; then
      ln -fs $REPO_DIR/.vim/dein/$file $dest_file
    fi
  done
fi

# install zgen
readonly ZGEN_DIR="$HOME/.zgen"
if [ ! -d $ZGEN_DIR ]; then
  git clone https://github.com/tarjoilija/zgen.git $ZGEN_DIR
fi

# install anyenv
readonly ANYENV_DIR="$HOME/.anyenv"
if [ ! -d $ANYENV_DIR ]; then
  git clone https://github.com/riywo/anyenv $ANYENV_DIR

  mkdir $ANYENV_DIR/plugins
  git clone https://github.com/znz/anyenv-update.git $ANYENV_DIR/plugins/anyenv-update
fi

# set default shell
readonly ZSH_DIR="/usr/local/bin/zsh"
readonly SHELL_FILE="/etc/shells"
if ! grep $ZSH_DIR $SHELL_FILE > /dev/null; then
  echo $ZSH_DIR | sudo tee -a $SHELL_FILE
fi

# create ssh directory
readonly SSH_DIR="$HOME/.ssh"
if [ ! -d $SSH_DIR  ]; then
  mkdir -p $SSH_DIR/conf.d
  chmod -R 700 $SSH_DIR
  cp $REPO_DIR/.ssh_config $SSH_DIR/ssh_config
  cp $REPO_DIR/.config $SSH_DIR/config
fi

# restart shell
exec -l $SHELL
