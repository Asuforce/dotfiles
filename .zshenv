# Defines environment variables.

if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

if [ -z $TMUX ]; then
  # language
  export LANG=ja_JP.UTF-8

  # PATH
  export PATH="/usr/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
  export PATH="/usr/local/bin:$PATH"

  # editor
  export EDITOR=/usr/bin/vim

  # for go
  export GOPATH="$HOME/local"
  export PATH=$PATH:$GOPATH/bin

  # for heroku
  if [ -d /usr/local/heroku ]; then
    export PATH="/usr/local/heroku/bin:$PATH"
    export PATH="./vendor/bin:$PATH"
  fi

  # for composer
  [ -d $HOME/.composer ] && export PATH="$HOME/.composesr/vendor/bin:$PATH"

  # for openssl
  export PATH=/usr/local/opt/openssl/bin:$PATH
  export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
  export CPATH=/usr/local/opt/openssl/include:$LD_LIBRARY_PATH
fi
