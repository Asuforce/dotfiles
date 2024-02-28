# Auto compile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

# Set locale
export LC_ALL=ja_JP.UTF-8

source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"

# Zsh plugin conf
MNML_PROMPT=(mnml_ssh mnml_pyenv 'mnml_cwd 0 0' mnml_status mnml_keymap kube_ps1 mnml_git)
MNML_RPROMPT=('')
MNML_USER_CHAR='#'
MNML_INSERT_CHAR='>'

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

  zgen load subnixr/minimal

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
  ID=`echo "${ls}\n${create_new_session}:" | fzf | cut -d: -f1`
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
    notify_title=$([ "$prev_command_status" -eq 0 ] && echo "Command succeeded" || echo "Command failed")
    osascript -e "display notification \"$prev_command\" with title \"$notify_title\""
  fi
}

store_command() {
  prev_command=$2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec store_command
add-zsh-hook precmd notify_precmd

# XDG base
export XDG_CONFIG_HOME="$HOME/.config"

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

# Query overwrite file
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# For eza alias & shortcut
alias ls='eza -GF'
alias ll='eza -l'
alias la='eza -alh'

# For vim
alias vi='vim'

# For git
alias g='git'

# For brew
if [ $(uname) = Linux ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin/:$PATH"
fi
export PATH="/usr/local/sbin:$PATH"

if [ $(uname -m) = arm64 ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

alias brew="env PATH=${PATH/\/Users\/${USER}\/\.anyenv\/envs\/pyenv\/shims:/} brew"
alias bu='env HOMEBREW_INSTALL_CLEANUP=1 brew upgrade --fetch-HEAD --ignore-pinned --display-times && brew upgrade --cask'

# For Docker
alias de='docker exec'
alias d-c='docker-compose'

# For kubectl
alias k='kubectl'
alias kg='kubectl get'
alias kc='kubectx'
alias kn='kubens'
alias kv='k9s'

# For reset
alias re='exec $SHELL -l'

# for fzf
fzf-z-search() {
  local res=$(z | sort -rn | cut -c 12- | fzf)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N fzf-z-search
bindkey '^v' fzf-z-search

fzf-src() {
  local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N fzf-src
bindkey '^j' fzf-src

fzf-history() {
  BUFFER=`history -n 1 | LC_ALL=C sort | uniq | fzf`
  CURSOR=$#BUFFER
}
zle -N fzf-history
bindkey '^]' fzf-history

git-branch-fzf() {
  local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | perl -pne 's{^refs/heads/}{}' | fzf --query "$LBUFFER")

  if [ -n "$selected_branch" ]; then
    BUFFER="git checkout ${selected_branch}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N git-branch-fzf
bindkey "^[" git-branch-fzf

tree-fzf() {
  local SELECTED_FILE=$(tree --charset=o -f | fzf --query "$LBUFFER" | tr -d '\||`|-' | xargs echo)

  if [ "$SELECTED_FILE" != "" ]; then
    BUFFER="$EDITOR $SELECTED_FILE"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N tree-fzf
bindkey "^t" tree-fzf

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
if [ $(uname) = Darwin ]; then
  alias sed='gsed'
fi

# For direnv
eval "$(direnv hook zsh)"

# For anyenv
if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  for D in `ls $HOME/.anyenv/envs | sed 's/\///g'`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# For npm
NPM_PATH="$HOME/.anyenv/envs/nodenv/versions/$(node -v | tr -d v)/bin"
if [ -d $NPM_PATH ]; then
  export PATH="$NPM_PATH:$PATH"
fi

anyenv_all() {
  unset -f plenv
  unset -f pyenv
  unset -f nodenv
  unset -f rbenv
  unset -f jenv

  eval "$(anyenv init - --no-rehash)"
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

# For curl
if [ -d /usr/local/opt/curl ]; then
  export PATH="/usr/local/opt/curl/bin:$PATH"
fi

# Do not register duplicate paths
typeset -U path cdpath fpath manpath

# for go
export GOPATH="$HOME/dev"
export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on

# Use zprof
if (which zprof > /dev/null) ;then
  zprof | less
fi

source "$HOME/.work.sh"

# Rancher Desktop
export PATH="/Users/sun/.rd/bin:$PATH"

