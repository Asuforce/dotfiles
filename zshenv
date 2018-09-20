# Use zprof
#zmodload zsh/zprof && zprof

# Defines environment variables.

if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

if [ -z $TMUX ]; then
  # language
  export LANG=ja_JP.UTF-8

  # PATH
  export PATH="$PATH:/usr/bin:"
  export PATH="$PATH:/usr/local/sbin"
  export PATH="$PATH:/usr/local/bin"

  # for go
  export GOPATH="$HOME/dev"
  export GOROOT="$GOPATH"
  export PATH="$PATH:$GOPATH/bin"

  #for rust
  export PATH="$HOME/.cargo/bin:$PATH"
fi
