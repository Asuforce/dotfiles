# Application Shortcuts
alias cot='open -g -a CotEditor' # ターミナルからCotEditorを開く
alias safari='open -g -a safari' # ターミナルからSafariを開く
alias console='open -a console' # ターミナルからコンソールを開く

# for shortcut
alias up='cd ..'
alias upp='cd ../..'
alias uppp='cd ../../..'
alias ls='ls -GwF'
alias la='ls -alh'
alias t='tar zxvf'
alias t-='tar xvf -'
alias b='bzip2 -dc'
alias dh='df -h'
alias vi='vim'
alias v='vim'
alias sr='screen -d -R'
alias grep='grep --exclude=*.svn*'
alias greprn='grep -rn --exclude=*.svn*'
alias bye='sudo shutdown -h now'

# for svn
alias st='svn st'
alias stu='svn st -u'
alias sd='svn di'
alias sdi='svn di'
alias sad='svn add'
alias sup='svn up'
alias sci='svn ci'
alias scim='svn ci -m'

# for git
alias gst='git status'
alias gci='git commit'
alias gdi='git diff'
alias gdc='git diff --cached'
alias gad='git add'

# rbenv
alias be='bundle exec'

# export
export PATH=~/bin:$PATH
export PATH=/usr/local/sbin:$PATH # for Homebrew
export PATH=/usr/local/bin:$PATH  # for Homebrew
export PATH=/usr/bin:$PATH
export PATH=/Users/Shun/pear/bin:$PATH
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=./vendor/bin:$PATH
MAUDE_LIB=/usr/local/maude
export MAUDE_LIB
alias maude="/usr/local/maude/maude.darwin64"
