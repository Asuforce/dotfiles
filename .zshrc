# Auto compile
if [[ ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi

# Set locale
export LC_ALL=ja_JP.UTF-8

# Load kube-ps1 if available
if command -v brew > /dev/null 2>&1; then
  local kube_ps1_path="$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
  [[ -f "$kube_ps1_path" ]] && source "$kube_ps1_path"
fi

# Zsh plugin conf
MNML_PROMPT=(mnml_ssh mnml_pyenv 'mnml_cwd 0 0' mnml_status mnml_keymap kube_ps1 mnml_git)
MNML_RPROMPT=('')
MNML_USER_CHAR='#'
MNML_INSERT_CHAR='>'

zgen_update() {
  source "$HOME/.zgen/zgen.zsh"
  zgen update
  zgen_init

  exec "$SHELL" -l
}

zgen_init () {
  source "$HOME/.zgen/zgen.zsh"

  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions
  zgen load rupa/z

  zgen load subnixr/minimal

  zgen save

  find "$HOME/.zgen" -name "*.zsh" -print0 | while IFS= read -r -d '' f; do
    zcompile "$f"
  done
}

if [[ ! -s "$HOME/.zgen/init.zsh" ]]; then
  zgen_init
else
  source "$HOME/.zgen/init.zsh"
fi

# Export brew bin path
if [[ "$(uname -m)" == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
fi

# Auto load tmux
if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  local ls="$(tmux list-sessions 2>/dev/null)"
  if [[ -z "$ls" ]]; then
    tmux new-session
  fi

  local create_new_session="Create New Session"
  local ID=$(printf "%s\n%s:\n" "$ls" "$create_new_session" | fzf | cut -d: -f1)
  if [[ "$ID" == "$create_new_session" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    : # Start terminal normally
  fi
fi

# Notify
notify_precmd() {
  prev_command_status=$?

  if [[ "${TTYIDLE:-0}" -gt 1 ]]; then
    local notify_title
    if [[ "$prev_command_status" -eq 0 ]]; then
      notify_title="Command succeeded"
    else
      notify_title="Command failed"
    fi
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

# Configure for history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
setopt SHARE_HISTORY

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
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.anyenv\/envs\/pyenv\/shims:/} brew"
alias bu='env HOMEBREW_INSTALL_CLEANUP=1 brew upgrade --fetch-HEAD --display-times && brew upgrade --cask'

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
  if [[ -n "$res" ]]; then
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
  if [[ -n "$selected_dir" ]]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N fzf-src
bindkey '^j' fzf-src

fzf-history() {
  BUFFER=$(history -n 1 | LC_ALL=C sort | uniq | fzf)
  CURSOR=$#BUFFER
}
zle -N fzf-history
bindkey '^]' fzf-history

git-branch-fzf() {
  local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | perl -pne 's{^refs/heads/}{}' | fzf --query "$LBUFFER")

  if [[ -n "$selected_branch" ]]; then
    BUFFER="git checkout ${selected_branch}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N git-branch-fzf
bindkey "^[" git-branch-fzf

tree-fzf() {
  local SELECTED_FILE=$(tree --charset=o -f | fzf --query "$LBUFFER" | tr -d '\||`|-' | xargs echo)

  if [[ -n "$SELECTED_FILE" ]]; then
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
  \ssh "$@"
  set_term_bgcolor 0 0 0
}

alias ssh='myssh'

# For vscode
alias e='code -r'

# For gnu-sed
if [[ "$(uname)" == "Darwin" ]]; then
  alias sed='gsed'
fi

# For direnv
eval "$(direnv hook zsh)"

# For anyenv
if [[ -d "$HOME/.anyenv" ]]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  for D in "$HOME/.anyenv/envs"/*; do
    [[ -d "$D/shims" ]] && export PATH="$D/shims:$PATH"
  done
fi

# Lazy load anyenv for version managers
_init_anyenv() {
  unset -f pyenv nodenv rbenv
  eval "$(anyenv init - --no-rehash)"
}

pyenv() {
  _init_anyenv
  pyenv "$@"
}

nodenv() {
  _init_anyenv
  nodenv "$@"
}

rbenv() {
  _init_anyenv
  rbenv "$@"
}

anyenv-update() {
  local _PWD="$(pwd)"
  local _ENVHOME="$HOME/.anyenv/envs"

  for _DIR in "$_ENVHOME"/*; do
    [[ ! -d "$_DIR" ]] && continue
    local _DIR_NAME=$(basename "$_DIR")
    echo "\n-- $_DIR_NAME --"
    local _HOME="$_DIR"
    cd "$_HOME"
    local _PULL="$(git pull)"
    echo "$_PULL"

    if [[ -d "$_HOME/plugins" ]]; then
      for _PLUGIN_DIR in "$_HOME/plugins"/*; do
        [[ ! -d "$_PLUGIN_DIR" ]] && continue
        local _PLUGIN_NAME=$(basename "$_PLUGIN_DIR")
        echo "$(pwd)"
        echo "\n-- $_PLUGIN_NAME --"
        cd "$_PLUGIN_DIR"
        local _PLUGIN_PULL="$(git pull)"
        echo "$_PLUGIN_PULL"
      done
    fi
  done

  cd "$_PWD"
}

# For curl
if [[ -d /usr/local/opt/curl ]]; then
  export PATH="/usr/local/opt/curl/bin:$PATH"
fi

# Do not register duplicate paths
typeset -U path cdpath fpath manpath

# for go
export GOPATH="$HOME/dev"
export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on


