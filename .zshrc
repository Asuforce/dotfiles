# auto compile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

# zgen conf
MNML_PROMPT=(mnml_ssh mnml_pyenv mnml_pwd mnml_status mnml_keymap mnml_git)
MNML_RPROMPT=('')

zgen_update() {
  source ${HOME}/.zgen/zgen.zsh
  zgen update
  zgen_init

  exec $SHELL -l
}

zgen_init () {
  source ${HOME}/.zgen/zgen.zsh

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

# tmux auto load
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

# alias 上書きファイルの問い合わせ
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# for shortcut
alias cat='bat'

# for exa alias & shortcut
alias ls='exa -GF'
alias ll='exa -l'
alias la='exa -alh'

# for vim
alias vi='vim'

# for git
alias g='git'

# for brew
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.anyenv\/envs\/pyenv\/shims:/} brew"
alias bu='brew upgrade --fetch-HEAD --ignore-pinned --display-times --cleanup && brew cask upgrade'

# for bundle
alias be='bundle exec'
alias bi='bundle install -j4 --path vendor/bundle'

# for Docker
alias de='docker exec'
alias d-c='docker-compose'

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
alias e='code'

# for gnu-sed
alias sed='gsed'

# for anyenv
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
    echo "\n-- ${_DIR} --"
    _HOME=${_ENVHOME}/${_DIR}
    cd ${_HOME}
    _PULL=`git pull`
    echo $_PULL

    for _DIR in `ls plugins`; do
      echo `pwd`
      echo "\n-- ${_DIR} --"
      cd "${_HOME}/plugins/${_DIR}"
      _PULL=`git pull`
      echo $_PULL
    done
  done

  cd ${_PWD}
}

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
JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
if [ -d ${JAVA_HOME} ]; then
  export JAVA_HOME=${JAVA_HOME}
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# for work script
WORK_SCRIPT="${HOME}/.work.sh"
if [ -s ${WORK_SCRIPT} ]; then
  source ${WORK_SCRIPT}
fi

# for flutter
FLUTTER_DIR="${HOME}/dev/src/github.com/flutter/flutter"
if [ -d ${FLUTTER_DIR} ]; then
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

# Use zprof
if (which zprof > /dev/null) ;then
  zprof | less
fi

