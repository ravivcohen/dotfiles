# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# It's my library. Let me see it.
sudo chflags nohidden ~/Library/
sudo chflags nohidden /tmp
sudo chflags nohidden /usr

##EXTRAA
# Link to the airport command
sudo ln -sf /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport

##Security
# Enable Firewall.
# Replace value with
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
# Enable Stealth mode.
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled 1
# Enable Firewall Logging.
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled 1
# Allow signed APPS
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -int 1

# Enable Require password to wake this computer from sleep or screen saver.
sudo defaults -currentHost write com.apple.screensaver askForPassword -int 1
# Disable Automatic login.
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool yes

# Require password to unlock each System Preference pane.
# Edit the /etc/authorization file using a text editor.
# Find <key>system.preferences<key>.
# Then find <key>shared<key>.
# Then replace <true/> with <false/>.
security authorizationdb read system.preferences > /tmp/system.preferences.plist
defaults write /tmp/system.preferences.plist shared -bool false
sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
sudo rm -rf /tmp/system.preferences.plist

# Disable automatic login.
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0

# Disable IR remote control.
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
# Turn Bluetooth off.
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

# Disable location services
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.locationd.plist 

## Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"


# Disable internal microphone or line-in.
# This command does not change the input volume for input devices. It
# only sets the default input device volume to zero.
sudo osascript -e "set volume input volume 0"

# These are disabled by default but just to make sure we add them
# Disable Web Sharing.
sudo launchctl unload -wF /System/Library/LaunchDaemons/org.apache.httpd.plist
sudo launchctl unload -wF /System/Library/LaunchDaemons/ssh.plist
# Disable Remote Management.
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
# Disable Remote Apple Events.
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.eppc.plist
# Disable Internet Sharing.
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.InternetSharing.plist
# Disable Bluetooth Sharing.
sudo defaults -currentHost write com.apple.bluetooth PrefKeyServicesEnabled 0

# Turn off AirPort Services using the following commands. Run the last
# command as the current user.
#sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.airportPrefsUpdater.plist
#sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.AirPort.wps.plist
#launchctl unload -wF /System/Library/LaunchAgents/com.apple.airportd.plist
# Turn off Screen Sharing services.
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.RFBEventHelper.plist
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.screenSharing.plist

# Turn off Remote Management service using the following commands:
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.RemoteDesktop.PrivilegeProxy.plist
# Turn off Bluetooth service using the following command:
sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.blued.plist

# Destroy File Vault Key when going to standby
 # mode. By default File vault keys are retained even when system goes
 # to standby. If the keys are destroyed, user will be prompted to
 # enter the password while coming out of standby mode.(value: 1 -
 # Destroy, 0 - Retain)
sudo pmset -a destroyfvkeyonstandby 1
# #We do not recommend modifying hibernation settings. Any changes you
#      make are not supported. If you choose to do so anyway, we recommend
#      using one of these three settings. For your sake and mine, please
#      don't use anything other 0, 3, or 25.

#      hibernatemode = 0 (binary 0000) by default on supported desktops.
#      The system will not back memory up to persistent storage. The system
#      must wake from the contents of memory; the system will lose context
#      on power loss. This is, historically, plain old sleep.

#      hibernatemode = 3 (binary 0011) by default on supported portables.
#      The system will store a copy of memory to persistent storage (the
#      disk), and will power memory during sleep. The system will wake from
#      memory, unless a power loss forces it to restore from disk image.

#      hibernatemode = 25 (binary 0001 1001) is only settable via pmset.
#      The system will store a copy of memory to persistent storage (the
#      disk), and will remove power to memory. The system will restore from
#      disk image. If you want "hibernation" - slower sleeps, slower wakes,
#      and better battery life, you should use this setting.
sudo pmset -a hibernatemode 25
# Enable hard disk sleep.
sudo pmset -a disksleep 45

# Disable computer sleep.
sudo pmset -a sleep 90
# Display sleep
sudo pmset -a displaysleep 45
# Disable Wake for Ethernet network administrator access.
sudo pmset -a womp 0
# Disable Restart automatically after power failure.
sudo pmset -a autorestart 0
# specifies the delay, in seconds, before writing the
# hibernation image to disk and powering off memory for Standby.
sudo pmset -a standbydelay 300


# Remove the Java browser Plugin. NO LONGER NEEDED ?!?
# Apple by default disables this in http://support.apple.com/kb/dl1572
# java_plugin="/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin"
# sudo rm -rf $java_plugin
# sudo touch $java_plugin
# sudo chmod 000 $java_plugin
# sudo chflags uchg $java_plugin