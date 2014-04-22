# Abort if not first run
[[ "$new_dotfiles_install" ]] || return 1

# Setup the needed DIRS
mkdir -p $DOTFILES_HOME/Development
mkdir -p $DOTFILES_HOME/Engagements
mkdir -p $DOTFILES_HOME/Tools
mkdir -p $DOTFILES_HOME/Resources
mkdir -p $DOTFILES_HOME/Documents

# Here Everyhting is orgnaized into logical groups
# Sublime
# OSX
if [[ "$OSTYPE" =~ ^darwin ]]; then
	# Make sirectory if it does not exist
	mkdir -p $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
	mkdir -p $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/
	# Get the latest package manager
	curl -fsSL https://sublime.wbond.net/Package%20Control.sublime-package -o $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package
	# Remove the current user folder 
	rm -rf $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
	# Link our User directory
	ln -s $DOTFILES_HOME/.dotfiles/conf/sublime/User $DOTFILES_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
	
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
