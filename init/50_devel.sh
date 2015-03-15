
#All Helper functions can now be found inside libs/helper_functions.
. $lib_file

# Here Everyhting is orgnaized into logical groups
# Sublime
# OSX
if [[ "$OSTYPE" =~ ^darwin ]]; then

	# Setup OSX for Personal Use
	# Setup the needed DIRS
	mkdir -p $DOTFILES_HOME/Development
	mkdir -p $DOTFILES_HOME/Engagements
	mkdir -p $DOTFILES_HOME/Tools
	mkdir -p $DOTFILES_HOME/Resources
	mkdir -p $DOTFILES_HOME/Resources/Deliverables
	mkdir -p $DOTFILES_HOME/Resources/Training
	mkdir -p $DOTFILES_HOME/Virtual_Machines
	mkdir -p $DOTFILES_HOME/Documents
	
    ##Configure Mutt
    mkdir -p $DOTFILES_HOME/.mail
    mkdir -p $DOTFILES_HOME/.mail/mutt/temp
    mkdir -p $DOTFILES_HOME/.mail/mutt/cache/headers 
    mkdir -p $DOTFILES_HOME/.mail/mutt/cache/bodies  
    mkdir -p $DOTFILES_HOME/.mail/mutt/temp          
    
    mkdir -p $DOTFILES_HOME/.mutt/certificates  
    mkdir -p $DOTFILES_HOME/.mutt/alias
    mkdir -p $DOTFILES_HOME/.mutt/mailcap       
    mkdir -p $DOTFILES_HOME/.mutt/sig       
    
    loaded="$(launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"
    is_loaded=($(setdiff 1 "homebrew.mxcl.offline-imap" "$loaded"))
    is_installed=($(setcomp 1 "offline-imap" "$(brew list)"))
    if [[  "$is_loaded" -eq 0 ]] && [[ "$is_installed" -eq 1 ]]; then
        e_header "Loading offline-imap launchctl"
        #Add offline-imap to launch
        mkdir -p ~/Library/LaunchAgents
        cp /usr/local/opt/offline-imap/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.offline-imap.plist
    fi

	# Make sirectory if it does not exist
	mkdir -p $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
	mkdir -p $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/
	
	if [[ ! -e "$DOTFILES_HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package" ]]; then
		e_header "Downloading sublime-package-manager"
		# Get the latest package manager
		curl -fsSL https://sublime.wbond.net/Package%20Control.sublime-package -o $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package
	fi

	if [[ ! -L "$DOTFILES_HOME/Library/Application Support/Sublime Text 3/Packages/User" ]]; then
    	e_header "Linking Sublime user directory"
    	# Remove the current user folder 
		rm -rf $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
		# Link our User directory
		ln -s $DOTFILES_HOME/.dotfiles/conf/sublime/User $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
  	fi
  		
	
# Ubuntu.
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
	#TODO
	echo 'Fix Sublime Init'
fi
# # rbenv init.
# PATH=$(path_remove ~/.dotfiles/libs/rbenv/bin):~/.dotfiles/libs/rbenv/bin
# PATH=$(path_remove ~/.dotfiles/libs/ruby-build/bin):~/.dotfiles/libs/ruby-build/bin
# 
# if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
#   eval "$(rbenv init -)"
# fi
# 
# # Install Ruby.
# if [[ "$(type -P rbenv)" ]]; then
#   versions=(1.9.3-p194 1.9.2-p290)
# 
#   list="$(to_install "${versions[*]}" "$(rbenv whence ruby)")"
#   if [[ "$list" ]]; then
#     e_header "Installing Ruby versions: $list"
#     for version in $list; do rbenv install "$version"; done
#     [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rbenv global "${versions[0]}"
#     rbenv rehash
#   fi
# fi
# 
# # Install Gems.
# if [[ "$(type -P gem)" ]]; then
#   gems=(bundler awesome_print interactive_editor)
# 
#   list="$(to_install "${gems[*]}" "$(gem list | awk '{print $1}')")"
#   if [[ "$list" ]]; then
#     e_header "Installing Ruby gems: $list"
#     gem install $list
#   fi
# fi
# 
