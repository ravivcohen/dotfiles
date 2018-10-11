is_osx || return 1

# Setup OSX for Personal Use
# Setup the needed DIRS
mkdir -p $USER_HOME/Virtual_Machines
mkdir -p $USER_HOME/Documents

## SUBLIME

if [[ ! -d "$USER_HOME/Library/Application Support/Sublime Text 3/" ]]; then
    
    mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
    mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

    e_header "Downloading sublime-package-manager"
    # Get the latest package manager
    curl -fsSL https://packagecontrol.io/Package%20Control.sublime-package -o $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package

    e_header "Configuring Sublime"
    # Link needed files from user directory
    ln -sF $DOTFILES_HOME/conf/sublime/user/* $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

    # Chane Sublime ICON cause why not 
    if [[ -e "/Applications/Sublime Text.app/Contents/Resources/Sublime Text.icns" ]]; then

        e_header "Copying over Sublime Icon"
        cp "$DOTFILES_HOME/conf/sublime/Sublime Text.icns" "/Applications/Sublime Text.app/Contents/Resources/"

    fi

fi



## SUBLIME
    
# OSX Config. Can safely be run everytime.
e_header "Running OSX Local Config"
source $DOTFILES_HOME/conf/osx/conf_osx.sh

## iTERM
# IF Iterm has never been run this wont exsit. 
# We then run iterm so we can config it.
if [[ ! -e ~/Library/Preferences/com.googlecode.iterm2.plist ]]; then

    # Open iTerm to set all files in place.
    open -a iTerm
    sleep 1
    kill $(pgrep -f iTerm2)
fi

# Now for iTerm to load its settting from an external location.
defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool TRUE
defaults write  ~/Library/Preferences/com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iTerm/";
## iTERM
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'$DOTFILES_HOME'/conf/bkrd.jpg"'
        
