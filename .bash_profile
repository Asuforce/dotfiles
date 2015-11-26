if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# rbenv
export PATH="$PATH:$HOME/.rbenv/shims"
eval "$(rbenv init -)"

if [[ -s ~/.nvm/nvm.sh ]];
 then source ~/.nvm/nvm.sh
fi

