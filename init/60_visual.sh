if [[ "$OSTYPE" =~ ^darwin ]]; then
	
    e_header "Setting Up OSX Visual Settings"
 	# Terminal
	# ========
	
    # IF Iterm has never been run this wont exsit. 
    # We then run iterm so we can config it.
    if [[ ! -e ~/Library/Preferences/com.googlecode.iterm2.plist ]]; then

        # Open iTerm to set all files in place.
        open -a iTerm
        sleep 1
        killall iTerm
    fi

    # Now for iTerm to load its settting from an external location.
    defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool TRUE
    defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iTerm/";
    

# Ubuntu.
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
	#TODO
	echo 'Fix Visual Init'
fi

if [[ ! -e $HOME/.oh-my-zsh ]]; then
    # 2. Second We Setup OH-MY-ZSH  
    e_header "Setup oh-my-zsh"
    ##SETUP OH MY ZSH ONLY ON THE FIRST TIME
    curl -L http://install.ohmyz.sh | sh
    #We have to set ZSH shell to Homebrew version
    chsh -s /usr/local/bin/zsh
fi