# Abort if not first run
[[ "$new_dotfiles_install" ]] || return 1

if [[ "$OSTYPE" =~ ^darwin ]]; then
	e_header "Setting Up OSX Visual Settings"
 	# Terminal
	# ========
	# Get fonts.
	osx_conf_dir = $DOTFILES_HOME/.dotfiles/conf/osx
	brew cask install --fontdir=/Library/Fonts --force $osx_conf_dir/powerline-fonts/font-dejavu-sans-mono-for-powerline.rb
	brew cask install --fontdir=/Library/Fonts --force $osx_conf_dir/powerline-fonts/font-sauce-code-powerline.rb
	brew cask install --fontdir=/Library/Fonts --force $osx_conf_dir/powerline-fonts/font-inconsolata-powerline.rb
	brew cask install --fontdir=/Library/Fonts --force $osx_conf_dir/powerline-fonts/font-inconsolata-dz-powerline.rb
	brew cask install --fontdir=/Library/Fonts --force $osx_conf_dir/powerline-fonts/font-meslo-powerline.rb
	
	# # Use a modified version of the Pro theme by default in Terminal.app
	# TODO FIX!!!
	open "$osx_conf_dir/terminal-colors-solarized/Solarized Dark.terminal"
	sleep 1 # Wait a bit to make sure the theme is loaded
	open "$osx_conf_dir/terminal-colors-solarized/Solarized Light.terminal"
	sleep 1
	open "$DOTFILES_HOME/.dotfiles/conf/tomorrow-theme/OS X Terminal/Tomorrow.terminal"
	sleep 1	
	open "$DOTFILES_HOME/.dotfiles/conf/tomorrow-theme/OS X Terminal/Tomorrow Night.terminal"
	sleep 1	
	open "$DOTFILES_HOME/.dotfiles/conf/tomorrow-theme/OS X Terminal/Tomorrow Night Blue.terminal"
	sleep 1	
	open "$DOTFILES_HOME/.dotfiles/conf/tomorrow-theme/OS X Terminal/Tomorrow Night Bright.terminal"
	sleep 1	
	open "$DOTFILES_HOME/.dotfiles/conf/tomorrow-theme/OS X Terminal/Tomorrow Night Eighties.terminal"
	sleep 1

	# We need to set the default font + Default Theme
	
	
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
