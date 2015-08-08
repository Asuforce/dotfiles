if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/shims:$PATH"


if [[ -s ~/.nvm/nvm.sh ]];
 then source ~/.nvm/nvm.sh
fi

PATH=/Applications/Xcode6.app//Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH
