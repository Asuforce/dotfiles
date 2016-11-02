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

# 環境変数
export LANG=ja_JP.UTF-8

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

# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

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
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# custom command
function mkcd() { mkdir -p $1 && cd $1; }

# alias
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# for shortcut
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias ls='ls -GwF'
alias la='ls -alh'
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
alias gconfig='git config --local user.email asuforcegt@hotmail.co.jp && git config --local user.name asuforce'

# for brew
alias brew='env PATH=${PATH/\/usr\/local\/\phpenv\/shims:/} brew'
alias bfu='brew update && brew upgrade && brew cleanup'
export HOMEBREW_GITHUB_API_TOKEN=46d4ffac3de79592953af7b2cd3f5227dc7bfdd8

# for bundle
alias be='bundle exec'

# for vagrant
alias vu='vagrant up'
alias vs='vagrant ssh'


# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="./vendor/bin:$PATH"

# GO
export GOPATH="$HOME/.go"
export PATH=$PATH:$GOPATH/bin

# Docker
alias de="docker exec"

if [ -d $HOME/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    for D in `ls $HOME/.anyenv/envs`
    do
      export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

# composer
export PATH="$HOME/.composesr/vendor/bin:$PATH"

# nvim
export XDG_CONFIG_HOME="$HOME/.config"

# PATH
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export HOMEBREW_GITHUB_API_TOKEN=289540fb3dd02bab5069985370b41fb6201fabef

# peco
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

source ~/.z_lib/z.sh

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# added by travis gem
[ -f /Users/usr0600439/.travis/travis.sh ] && source /Users/usr0600439/.travis/travis.sh
