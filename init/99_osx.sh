[[ is_osx ]] || return 1

e_header "Running OSX Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/conf/osx/conf_osx.sh

# After we fixed the perms we need to re init ZSH
rm -rf $USER_HOME/.zcompdump*
zsh -c "autoload -U compinit; compinit -i"

## SUBLIME
# Make sirectory if it does not exist
mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
mkdir -p $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/

if [[ ! -e "$USER_HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package" ]]; then
    e_header "Downloading sublime-package-manager"
    # Get the latest package manager
    curl -fsSL https://sublime.wbond.net/Package%20Control.sublime-package -o $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package
fi

if [[ ! -L "$USER_HOME/Library/Application Support/Sublime Text 3/Packages/User" ]]; then
    e_header "Linking Sublime user directory"
    # Remove the current user folder 
    rm -rf $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    # Link our User directory
    ln -s $DOTFILES_HOME/conf/sublime/User $USER_HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
fi

## iTERM
e_header "Setting Up OSX Visual Settings"
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

    ##Configure Mutt
    mkdir -p $USER_HOME/.mail
    mkdir -p $USER_HOME/.mail/mutt/temp
    mkdir -p $USER_HOME/.mail/mutt/cache/headers 
    mkdir -p $USER_HOME/.mail/mutt/cache/bodies  
    mkdir -p $USER_HOME/.mail/mutt/temp          

    mkdir -p $USER_HOME/.mutt/certificates  
    mkdir -p $USER_HOME/.mutt/alias
    mkdir -p $USER_HOME/.mutt/mailcap       
    mkdir -p $USER_HOME/.mutt/sig       

    loaded="$(launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"
    is_loaded=($(setdiff "homebrew.mxcl.offline-imap" "$loaded"))
    is_installed=($(setcomp "offline-imap" "$(brew list)"))
    if [[ "${#is_loaded[@]}" -ne 0 ]] && [[ "${#is_installed[@]}" -eq 1 ]]; then
        e_header "Loading offline-imap launchctl"
        #Add offline-imap to launch
        mkdir -p $USER_HOME/Library/LaunchAgents
        cp /usr/local/opt/offline-imap/*.plist $USER_HOME/Library/LaunchAgents
        launchctl load $USER_HOME/Library/LaunchAgents/homebrew.mxcl.offline-imap.plist
    fi
fi