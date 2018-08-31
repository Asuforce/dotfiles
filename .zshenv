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

  # for go
  export GOPATH="$HOME/dev"
  export GOROOT="$GOPATH"
  export PATH="$PATH:$GOPATH/bin"

  # for heroku
  export PATH="/usr/local/heroku/bin:$PATH"
  export PATH="./vendor/bin:$PATH"

  #for rust
  export PATH="$HOME/.cargo/bin:$PATH"
fi
