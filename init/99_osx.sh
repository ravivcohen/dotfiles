is_osx || return 1

e_header "Running OSX Local Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/conf/osx/conf_osx.sh

## SUBLIME
# Make sirectory if it does not exist
mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/
mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

if [[ ! -e "$USER_HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package" ]]; then
    e_header "Downloading sublime-package-manager"
    # Get the latest package manager
    curl -fsSL https://sublime.wbond.net/Package%20Control.sublime-package -o $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package
fi

if [[ ! -L "$USER_HOME/Library/Application Support/Sublime Text 3/Packages/User/Package Control.sublime-settings" ]]; then
    e_header "Configuring Sublime"
    # Remove the current user folder 
    rm -rf $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/*
    # Link needed files from user directory
    ln -sF $DOTFILES_HOME/conf/sublime/User/* $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
fi

## iTERM
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
    

mkdir -p $USER_HOME/Development
mkdir -p $USER_HOME/Tools
        
if [ -z "$not_personal" ]; then

    ##   
    if [ -d "$USER_HOME/conf/dotfiles" ]; then
        e_header "Linking CONF files"
        ln -s $USER_HOME/conf/dotfiles/.* $USER_HOME/ 2>/dev/null
    fi

    # Setup OSX for Personal Use
    # Setup the needed DIRS
    mkdir -p $USER_HOME/Engagements
    mkdir -p $USER_HOME/Resources
    mkdir -p $USER_HOME/Resources/Deliverables
    mkdir -p $USER_HOME/Resources/Training
    mkdir -p $USER_HOME/Virtual_Machines
    mkdir -p $USER_HOME/Documents
fi