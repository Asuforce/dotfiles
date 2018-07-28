# auto compile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

# zgen conf
AGKOZAK_MULTILINE=0
ZGEN_FILE="$HOME/.zgen/zgen.zsh"
. $ZGEN_FILE

if ! zgen saved; then
  zgen load zsh-users/zsh-completions
  zgen load mollifier/cd-gitroot
  zgen load b4b4r07/auto-fu.zsh
  zgen load mafredri/zsh-async
  zgen load rupa/z

  zgen load agkozak/agkozak-zsh-theme

  zgen save
fi

# tmux auto load
is_exists() { type "$1" >/dev/null 2>&1; return $?; }
is_osx() { [[ $OSTYPE == darwin* ]]; }
is_screen_running() { [ ! -z "$STY" ]; }
is_tmux_runnning() { [ ! -z "$TMUX" ]; }
is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
shell_has_started_interactively() { [ ! -z "$PS1" ]; }
is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

tmux_automatically_attach_session() {
  if is_screen_or_tmux_running; then
    ! is_exists 'tmux' && return 1
  else
    if shell_has_started_interactively && ! is_ssh_running; then
      if ! is_exists 'tmux'; then
        echo 'Error: tmux command not found' 2>&1
        return 1
      fi

      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
          tmux attach-session
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
          tmux attach -t "$REPLY"
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        fi
      fi

      if is_osx && is_exists 'reattach-to-user-namespace'; then
        # on OS X force tmux's default command
        # to spawn a shell in the user's namespace
        tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
      else
        tmux new-session && echo "tmux created new session"
      fi
    fi
  fi
}
tmux_automatically_attach_session

# notify
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

# 色を使用出来るようにする
autoload -Uz colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE

# editor
export EDITOR=vim

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default

# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# ctrl系の操作
bindkey -e

# custom command
mkcd() { mkdir -p $1 && cd $1; }

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# alias 上書きファイルの問い合わせ
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# for shortcut
alias ls='ls -GwF'
alias ll='ls -l'
alias la='ls -alh'

# for vim
alias vi='vim'

# for git
alias g='git'

# for brew
alias bu='brew upgrade --force-bottle --cleanup && brew cask upgrade && brew cask cleanup'

# for bundle
alias be='bundle exec'
alias bi='bundle install -j4 --path vendor/bundle'

# for Docker
alias de='docker exec'
alias d-c='docker-compose'

# for Platinum Searcher
alias ptg='pt —vcs-ignore=""'

# for peco
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

# for ssh
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

# for vagrant
alias vu='vagrant up'
alias vd='vagrant destroy'
alias vp='vagrant provision'
alias vs='vagrant status'
alias vssh='vagrant ssh'

# for vscode
open_editor() { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
alias e='open_editor'

# for gnu-sed
alias sed='gsed'

# for anyenv
eval "$(direnv hook zsh)"

if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - --no-rehash zsh)"
  for D in `ls $HOME/.anyenv/envs | sed 's/\///g'`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# for kubernetes
if type kubectl > /dev/null 2>&1; then
  . <(kubectl completion zsh)
  alias kube='kubectl'
fi

# for openssl
if [ -d /usr/local/opt/openssl ]; then
  export PATH="/usr/local/opt/openssl/bin:$PATH"
  export LD_LIBRARY_PATH="/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH"
  export CPATH="/usr/local/opt/openssl/include:$LD_LIBRARY_PATH"
fi

# for curl
if [ -d /usr/local/opt/curl ]; then
  export PATH="/usr/local/opt/curl/bin:$PATH"
fi

# for java
if [ -d `/usr/libexec/java_home -v "1.8"` ]; then
  export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
  export PATH="$JAVA_HOME/bin:$PATH"
fi
