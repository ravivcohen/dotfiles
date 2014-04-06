# Abort if not first run
[[ "$new_dotfiles_install" ]] || return 1

if [[ "$OSTYPE" =~ ^darwin ]]; then
	e_header "Setting Up OSX Visual Settings"
 	# Terminal
	# ========
	#copy fonts
	# TODO make this into a submodule at some point
	cp $DOTFILES_HOME/.dotfiles/conf/osx/powerline-fonts/* $DOTFILES_HOME/Library/Fonts/
	# # Use a modified version of the Pro theme by default in Terminal.app
	open "$DOTFILES_HOME/.dotfiles/conf/osx/solarized-osx-terminal-colors/xterm-256color/Solarized Dark.terminal"
	sleep 1 # Wait a bit to make sure the theme is loaded
	open "$DOTFILES_HOME/.dotfiles/conf/osx/solarized-osx-terminal-colors/xterm-256color/Solarized Light.terminal"
	sleep 1 # Wait a bit to make sure the theme is loaded

# Ubuntu.
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
	#TODO
	echo 'Fix Visual Init'
fi

# 2. Second We Setup OH-MY-ZSH  
e_header "Setup oh-my-zsh"
##SETUP OH MY ZSH ONLY ON THE FIRST TIME
curl -L http://install.ohmyz.sh | sh
#We have to set ZSH shell to Homebrew version
chsh -s /usr/local/bin/zsh
