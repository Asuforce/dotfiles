# Auto compile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

# Zsh plugin conf
MNML_PROMPT=(mnml_ssh mnml_pyenv mnml_pwd mnml_status mnml_keymap mnml_git)
MNML_RPROMPT=('')
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

zgen_update() {
  source ${HOME}/.zgen/zgen.zsh
  zgen update
  zgen_init

  exec $SHELL -l
}

zgen_init () {
  source ${HOME}/.zgen/zgen.zsh

  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions
  zgen load rupa/z

  zgen load asuforce/minimal

  zgen save

  for f in `find "${HOME}/.zgen" -name "*.zsh"`; do
    zcompile $f
  done
}

if [ ! -s ${HOME}/.zgen/init.zsh ]; then
  zgen_init
else
  source ${HOME}/.zgen/init.zsh
fi

# Auto load tmux
if [[ ! -n $TMUX ]] && [[ $TERM_PROGRAM != "vscode" ]]; then
  ls=`tmux list-sessions`
  if [[ -z "${ls}" ]]; then
    tmux new-session
  fi

  create_new_session="Create New Session"
  ID=`echo "${ls}\n${create_new_session}:" | peco | cut -d: -f1`
  if [[ "${ID}" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "${ID}" ]]; then
    tmux attach-session -t "${ID}"
  else
    : # Start terminal normally
  fi
fi

# Notify
notify_precmd() {
  prev_command_status=$?

  if [ "$TTYIDLE" -gt 1 ]; then
    notify_title=$([ "$prev_command_status" -eq 0 ] && echo "Command succeeded \U1F646" || echo "Command failed \U1F645")
    osascript -e "display notification \"$prev_command\" with title \"$notify_title\""
  fi
}

store_command() {
  prev_command=$2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec store_command
add-zsh-hook precmd notify_precmd

# Change colors
autoload -Uz colors

# Configure for hostory
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE

export EDITOR=vim

# Specify word delimiter
autoload -Uz select-word-style
select-word-style default

# Match lowercase letters or capital letters in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# After ../ do not complement the directory that is now
zstyle ':completion:*' ignore-parents parent pwd ..

# Process name completion of ps command
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# Options
# Make Japanese filename displayable
setopt print_eight_bit

# Disable beep
setopt no_beep

# Disable flow control
setopt no_flow_control

# Do not quit zsh with Ctrl + D
setopt ignore_eof

# Treat after '#' as comment
setopt interactive_comments

# Cd by directory name alone
setopt auto_cd

# Automatically pushd after cd
setopt auto_pushd

# Do not add duplicate directory name
setopt pushd_ignore_dups

# Sharing the history among zshs started at the same time
setopt share_history

# Do not leave the same command in the history
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Command lines beginning with a space are not left in the history
setopt hist_ignore_space

# Delete extra space when saved in history
setopt hist_reduce_blanks

# Use advanced wildcard deployment
setopt extended_glob

# Make wildcard available with * when ^ R search history search
bindkey '^R' history-incremental-pattern-search-backward

# Control type of ctrl
bindkey -e

# Custom command
mkcd() { mkdir -p $1 && cd $1; }

# Query overwrite file
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# For shortcut
alias cat='bat'

# For exa alias & shortcut
alias ls='exa -GF'
alias ll='exa -l'
alias la='exa -alh'

# For vim
alias vi='vim'

# For git
alias g='git'

# For brew
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.anyenv\/envs\/pyenv\/shims:/} brew"
alias bu='env HOMEBREW_INSTALL_CLEANUP=1 brew upgrade --fetch-HEAD --ignore-pinned --display-times && brew cask upgrade'

# For bundle
alias be='bundle exec'
alias bi='bundle install -j4 --path vendor/bundle'

# For Docker
alias de='docker exec'
alias d-c='docker-compose'

# For peco
peco-z-search() {
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
bindkey '^v' peco-z-search

peco-src() {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^j' peco-src

peco-history() {
  BUFFER=`history -n 1 | sort -k1,1nr | sort | uniq | peco`
  CURSOR=$#BUFFER
}
zle -N peco-history
bindkey '^]' peco-history

# For ssh
set_term_bgcolor() {
  local R=${1}*65535/255
  local G=${2}*65535/255
  local B=${3}*65535/255

  /usr/bin/osascript <<EOF
  tell application "iTerm2"
    tell current session of current window
      set background color to {$R, $G, $B}
    end tell
  end tell
EOF
}

myssh() {
  set_term_bgcolor 0 0 30
  \ssh $@
  set_term_bgcolor 0 0 0
}

alias ssh='myssh'

# For vscode
alias e='code -r'

# For gnu-sed
alias sed='gsed'

# For anyenv
eval "$(direnv hook zsh)"

if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  for D in `ls $HOME/.anyenv/envs | sed 's/\///g'`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

anyenv_all() {
  unset -f goenv
  unset -f plenv
  unset -f pyenv
  unset -f nodenv
  unset -f rbenv

  eval "$(anyenv init - --no-rehash)"
}

goenv() {
  anyenv_all
  goenv "$@"
}

plenv() {
  anyenv_all
  plenv "$@"
}

pyenv() {
  anyenv_all
  pyenv "$@"
}

nodenv() {
  anyenv_all
  nodenv "$@"
}

rbenv() {
  anyenv_all
  rbenv "$@"
}

anyenv-update() {
  _PWD=`pwd`
  _ENVHOME="${HOME}/.anyenv/envs"

  for _DIR in `ls ${_ENVHOME}`; do
    echo "\n-- $(echo ${_DIR} | sed 's/\///g') --"
    _HOME=${_ENVHOME}/${_DIR}
    cd ${_HOME}
    _PULL=`git pull`
    echo $_PULL

    for _DIR in `ls plugins`; do
      echo `pwd`
      echo "\n-- $(echo ${_DIR} | sed 's/\///g') --"
      cd "${_HOME}/plugins/${_DIR}"
      _PULL=`git pull`
      echo $_PULL
    done
  done

  cd ${_PWD}
}

# For openssl
if [ -d /usr/local/opt/openssl ]; then
  export PATH="/usr/local/opt/openssl/bin:$PATH"
  export LD_LIBRARY_PATH="/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH"
  export CPATH="/usr/local/opt/openssl/include:$LD_LIBRARY_PATH"
fi

# For curl
if [ -d /usr/local/opt/curl ]; then
  export PATH="/usr/local/opt/curl/bin:$PATH"
fi

# For java
JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
if [ -d ${JAVA_HOME} ]; then
  export JAVA_HOME=${JAVA_HOME}
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# For work script
WORK_SCRIPT="${HOME}/.work.sh"
if [ -s ${WORK_SCRIPT} ]; then
  source ${WORK_SCRIPT}
fi

# For flutter
FLUTTER_DIR="${HOME}/dev/src/github.com/flutter/flutter"
if [ -d ${FLUTTER_DIR} ]; then
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

# For deno
DENO_DIR="${HOME}/.deno"
if [ -d ${DENO_DIR} ]; then
  export PATH="$DENO_DIR/bin:$PATH"
fi

# For mozjpeg
MOZJPEG_DIR="/usr/local/opt/mozjpeg"
if [ -d ${MOZJPEG_DIR} ]; then
  export PATH="${MOZJPEG_DIR}/bin:$PATH"
fi

# Do not register duplicate paths
typeset -U path cdpath fpath manpath

# Use zprof
if (which zprof > /dev/null) ;then
  zprof | less
fi

