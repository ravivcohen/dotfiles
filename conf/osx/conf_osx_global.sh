
if [[ "$new_dotfiles_install" ]]; then
  e_header "Setting Hostname"
  # Set computer name (as done via System Preferences → Sharing)
  HOSTNAME=$(sed `perl -e "print int rand(18)"`"q;d" /usr/share/dict/words)
  HOSTNAME+="$RANDOM"
  sudo scutil --set ComputerName "$HOSTNAME"
  sudo scutil --set HostName "$HOSTNAME"
  sudo scutil --set LocalHostName "$HOSTNAME"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server \
  NetBIOSName -string "$HOSTNAME"
fi

# It's my library. Let me see it.
sudo chflags nohidden ~/Library/
sudo chflags nohidden /tmp
sudo chflags nohidden /Volumes

#Disable Spotlight indexing from indexing /volume
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

#Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

#disable fast user switching 
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool NO

#diable username NO list in login
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

##Security
# Enable Firewall.
# Replace value with
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
# Enable Stealth mode.
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
# Enable Firewall Logging.
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true
# Allow signed APPS
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Enable Require password to wake this computer from sleep or screen saver.
sudo defaults -currentHost write com.apple.screensaver askForPassword -int 1
# Disable Automatic login.
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool yes

# Require password to unlock each System Preference pane.
# Edit the /etc/authorization file using a text editor.
# Find <key>system.preferences<key>.
# Then find <key>shared<key>.
# Then replace <true/> with <false/>.
security -q authorizationdb read system.preferences > /tmp/system.preferences.plist
defaults write /tmp/system.preferences.plist shared -bool false
sudo security -q authorizationdb write system.preferences < /tmp/system.preferences.plist
sudo rm -rf /tmp/system.preferences.plist

# Disable automatic login.
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0
# Disable IR remote control.
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool no
# Turn Bluetooth off.
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
# Disable Remote Management.
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop -quiet
# Disable Internet Sharing.
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
# Disable Bluetooth Sharing.
sudo defaults -currentHost write com.apple.bluetooth PrefKeyServicesEnabled 0

bad=("org.apache.httpd" "com.openssh.sshd")
loaded="$(sudo launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"

bad_list=($(setcomp "${bad[*]}" "$loaded"))
if (( ${#bad_list[@]} > 0 )); then
  for rmv in "${bad_list[@]}"; do
    e_header "Unloading: $rmv"
    launchctl unload -wF "/System/Library/LaunchAgents/"$rmv".plist"
  done
fi

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
sudo pmset -a disksleep 0
# Disable computer sleep.
sudo pmset -a sleep 0
# Display sleep
sudo pmset -a displaysleep 60
# Disable Wake for Ethernet network administrator access.
sudo pmset -a womp 0
# Disable Restart automatically after power failure.
sudo pmset -a autorestart 0
# specifies the delay, in seconds, before writing the
# hibernation image to disk and powering off memory for Standby.
sudo pmset -a standbydelay 300
# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null
