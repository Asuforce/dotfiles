# prezto conf
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# tmux auto load
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
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
function notify_precmd {
  prev_command_status=$?

  if [[ "$TTYIDLE" -gt 1 ]]; then
    notify_title=$([ "$prev_command_status" -eq 0 ] && echo "Command succeeded \U1F646" || echo "Command failed \U1F645")
    osascript -e "display notification \"$prev_command\" with title \"$notify_title\""
  fi
}

function store_command {
  prev_command=$2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec store_command
add-zsh-hook precmd notify_precmd

# language
export LANG=ja_JP.UTF-8

# editor
export EDITOR=/usr/bin/vim

# 色を使用出来るようにする
autoload -Uz colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

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
function mkcd() { mkdir -p $1 && cd $1; }

# PATH
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/Cellar/perl/5.24.0_1/bin:$PATH"

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# alias 上書きファイルの問い合わせ
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# for shortcut
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias ls='ls -GwF'
alias la='ls -alh'

# for vim
alias vi='vim'
alias v='vim'

# for git
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

alias g='git'
alias ggpu='git pull origin $(current_branch)'
alias ggpush='git push --set-upstream origin $(current_branch)'

# for brew
alias bu='brew upgrade --force-bottle --cleanup'
export HOMEBREW_GITHUB_API_TOKEN=9afbe05d9087c47fd838e0d1ce715ab7c9010b23

# for bundle
alias be='bundle exec'
alias bi='bundle install -j4 --path vendor/bundle'

# for heroku
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="./vendor/bin:$PATH"

# for go
export GOPATH="$HOME/local"
export PATH=$PATH:$GOPATH/bin

# for Docker
alias de='docker exec'
alias d-c='docker-compose'

# for Platinum Searcher
alias ptg='pt —vcs-ignore=""'

# for anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  for D in `ls $HOME/.anyenv/envs | sed 's/\///g'`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# for composer
export PATH="$HOME/.composesr/vendor/bin:$PATH"

# for nvim
export XDG_CONFIG_HOME="$HOME/.config"

# for peco
function peco-z-search
{
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

function peco-src
{
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^j' peco-src

function peco-history
{
  BUFFER=`history -n 1 | sort -k1,1nr | sort | uniq | peco`
  CURSOR=$#BUFFER
}
zle -N peco-history
bindkey '^]' peco-history

function peco-mkr-roles() {
  local selected_role=$(mkr services | jq -rM '[.[] | .name as $name | .roles // [] | map("\($name) \(.)")] | flatten | .[]' | peco)
  if [ -n "${selected_role}" ]; then
    local BUFFER="xpanes --ssh \`roles "${selected_role}"\`"
    zle accept-line // 好みでコメントアウトを外す
  fi
  zle clear-screen
}
zle -N peco-mkr-roles
bindkey '^w' peco-mkr-roles

# for z_lib
source ~/.z_lib/z.sh

# for openssl
export PATH=/usr/local/opt/openssl/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
export CPATH=/usr/local/opt/openssl/include:$LD_LIBRARY_PATH

# for direnv
eval "$(direnv hook zsh)"

# for ssh
function set_term_bgcolor() {
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

function myssh() {
  set_term_bgcolor 0 0 30
  \ssh $@
  set_term_bgcolor 0 0 0
}

alias ssh='myssh'

# for travis
[ -f /Users/usr0600439/.travis/travis.sh ] && source /Users/usr0600439/.travis/travis.sh

# for itunes
alias itunes='itunes-remote'

# for vagrant
alias vu='vagrant up'
alias vd='vagrant destroy'
alias vp='vagrant provision'
alias vs='vagrant status'
alias vssh='vagrant ssh'

# for nyah-cli
alias ne='nyah-exec -O mitaka'

# for tmux-xpanes
source ~/local/src/github.com/greymd/tmux-xpanes/activate.sh

# for mkr
export MACKEREL_APIKEY=cJ92HeIpWFe6OGyOqqUz3RivGGfFmAhzNesc5VdDt6E=

# for vscode
open_editor () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
alias e='open_editor'

# for gnu-sed
alias sed='gsed'

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
#
# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '%b'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
RPROMPT="%1(v|%F{green}%1v%f|)"
