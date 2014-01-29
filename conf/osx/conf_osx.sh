### UI
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true
# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0


###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots here instead of to desktop
defaults write com.apple.screencapture location "$HOME/Screenshots/"

# Disable drop shadow on screenshots
defaults write com.apple.screencapture disable-shadow -bool true


# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
#defaults write com.apple.screencapture type -string "png"

# Enable HiDPI display modes (requires restart)
#sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable stupid semitransparent menubar
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# I do not need my documents to be cloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# It's my library. Let me see it.
chflags nohidden ~/Library/
chflags nohidden /tmp
chflags nohidden /usr



###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "https://encrypted.google.com/"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


# Terminal
# ========

# Use a modified version of the Pro theme by default in Terminal.app
open "$pm/dotfiles/terminal/paulmillr.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
defaults write com.apple.terminal 'Default Window Settings' -string 'paulmillr'
defaults write com.apple.terminal 'Startup Window Settings' -string 'paulmillr'

##############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
# ANIMATE FASTER
defaults write com.apple.dock expose-animation-duration -float 0.15


# Use autohide but make it quick
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.17

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# Allow keyboard navigation for modals
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ANIMATE MORE FASTER
defaults write NSGlobalDomain NSWindowResizeTime .1

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false


# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true



###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
#hash tmutil &> /dev/null && sudo tmutil disablelocal

# Transmission
# ============

# Use `~/Documents/Torrents` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

##Security
# Disable "safe sleep", saving 8-16G of disk space. Doing so is basically no
# less secure than the default behavior when it comes to cold boot attacks, as
# Safe Sleep leaves the RAM powered for hours anyway. You'd have to hibernate
# every time you leave the machine to prevent that. If you want to do that, use
# this:
#
sudo pmset -a destroyfvkeyonstandby 1 hibernatemode 25
#
# You can also use autopoweroff and reduce the autopoweroffdelay if you want 
# to sleep -> hibernate after a period of time.
# pmset -a hibernatemode 0
# pmset -a autopoweroff 0
rm /private/var/vm/sleepimage

# Remove the Java browser Plugin.
rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
touch /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
chmod 000 /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
chflags uchg /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
