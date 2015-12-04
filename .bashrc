# for shortcut
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias ls='ls -GwF'
alias la='ls -alh'
alias vi='vim'
alias v='vim'

# for git
alias gst='git status'
alias gci='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gdf='git diff'
alias gdc='git diff --cached'
alias gad='git add'
alias gco='git checkout'

# fot bundle
alias be='bundle exec'

# export
export PATH=~/bin:$PATH
export PATH=/usr/local/sbin:$PATH # for Homebrew
export PATH=/usr/local/bin:$PATH  # for Homebrew
export PATH=/usr/bin:$PATH
export PATH=/Users/Shun/pear/bin:$PATH

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=./vendor/bin:$PATH
MAUDE_LIB=/usr/local/maude
export MAUDE_LIB
alias maude="/usr/local/maude/maude.darwin64"

# GO
export GOPATH=$HOME/.go
export PATH=$HOME/.go/bin:$PATH

# phpenv
export PHPENV_ROOT="$HOME/.phpenv"
export PATH="$PHPENV_ROOT/bin:$PATH"
eval "$(phpenv init -)"

# rbenv
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"

# composer
export PATH="$PATH:$HOME/.composer/vendor/bin"
