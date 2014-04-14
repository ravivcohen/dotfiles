# Abort if not first run
[[ "$new_dotfiles_install" ]] || return 1

if [[ "$OSTYPE" =~ ^darwin ]]; then
	e_header "Setting Up OSX Visual Settings"
 	# Terminal
	# ========
	# Get fonts.
	osx_conf_dir=$DOTFILES_HOME/.dotfiles/conf/osx
	fonts_dir=$osx_conf_dir/fonts
	for f in $fonts_dir/*.rb
	do
		brew cask install --fontdir=/Library/Fonts --force $f
	done

	# Download all the needed themes.
    # Theme URL array
    themes_array=("https://github.com/tomislav/osx-terminal.app-colors-solarized/raw/master/Solarized%20Dark.terminal"
            "https://github.com/chriskempson/tomorrow-theme/raw/master/OS%20X%20Terminal/Tomorrow%20Night.terminal"
            "https://github.com/chriskempson/tomorrow-theme/raw/master/OS%20X%20Terminal/Tomorrow%20Night%20Eighties.terminal"
            "https://github.com/chriskempson/tomorrow-theme/raw/master/iTerm2/Tomorrow%20Night.itermcolors"
            "https://github.com/chriskempson/tomorrow-theme/raw/master/iTerm2/Tomorrow%20Night%20Eighties.itermcolors"
            "https://github.com/altercation/solarized/raw/master/iterm2-colors-solarized/Solarized%20Dark.itermcolors "
            )
    for i in "${themes_array[@]}"
    do
            :
            # Strip https:/ and leave /
            url_name="$(echo $i | sed 's~http[s]*:/~~g')"
            # Pick last group in the path
            file_name=${url_name##/*/}
            # Get the File
            curl -fsSL $i -o $file_name
            # Open file so it get init and sleep 1 to give it time
            open $file_name
            sleep 1
            # Delete the no longer needed file.
            rm $file_name

    done

	# We need to set the default font + Default Theme
	defaults write com.apple.terminal "Default Window Settings" -string "SolarizedDark"
	defaults write com.apple.terminal "Startup Window Settings" -string "SolarizedDark"

	# Now for iTerm to load its settting from an external location.
	defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool TRUE
	defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iTerm/com.googlecode.iterm2.plist";
	
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
