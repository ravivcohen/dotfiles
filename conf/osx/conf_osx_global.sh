# All Helper functions can now be found inside libs/helper_functions.
. $lib_file

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "0x326c333374"
sudo scutil --set HostName "0x326c333374"
sudo scutil --set LocalHostName "0x326c333374"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x326c333374"

# It's my library. Let me see it.
sudo chflags nohidden ~/Library/
sudo chflags nohidden /tmp
sudo chflags nohidden /usr

##EXTRAA
# Link to the airport command
sudo ln -sf /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport

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

# Remove BAD services. In the future look at unloading these as well
# # com.apple.smb.preferences.plist $d
# # aosnotifyd -- Find My Mac daemon
# com.apple.AOSNotificationOSX.plist com.apple.locationd.plist com.apple.cmio.AVCAssistant.plist
# com.apple.cmio.VDCAssistant.plist com.apple.iCloudStats.plist com.apple.wwand.plist
# com.apple.AirPlayXPCHelper.plist
# # blued
# com.apple.blued.plist com.apple.bluetoothaudiod.plist com.apple.IOBluetoothUSBDFU.plist 
# com.apple.rpcbind.plist org.postfix.master.plist com.apple.spindump.plist
# com.apple.spindump_symbolicator.plist
# # metadata
# com.apple.metadata.mds.index.plist com.apple.metadata.mds.spindump.plist com.apple.metadata.mds.scan.plist
# com.apple.metadata.mds.plist com.apple.lockd.plist com.apple.nis.ypbind.plist com.apple.mbicloudsetupd.plist
# com.apple.gssd.plist com.apple.findmymac.plist com.apple.findmymacmessenger.plist 
# com.apple.cmio.IIDCVideoAssistant.plist com.apple.afpfs_checkafp.plist com.apple.afpfs_afpLoad.plist
# # Apple Push Notification service daemon
# com.apple.apsd.plist
# # awacsd -- Apple Wide Area Connectivity Service daemon
# com.apple.awacsd.plist
# # share service
# com.apple.RFBEventHelper.plist com.apple.cmio.AppleCameraAssistant.plist
# com.apple.revisiond.plist
# Turn off AirPort Services using the following commands. Run the last
# command as the current user.
#sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.airportPrefsUpdater.plist
#sudo launchctl unload -wF /System/Library/LaunchDaemons/com.apple.AirPort.wps.plist
# Another way to reomve is
# home=$HOME
# d=$home/backup-unload-daemon
# sudo mv /System/Library/LaunchDaemons/com.apple.mdmclient.daemon.plist $d

#"com.apple.locationd" 
bad=("org.apache.httpd" "com.openssh.sshd" 
	"com.apple.eppc" "com.apple.InternetSharing" "com.apple.RFBEventHelper" 
	"com.apple.screensharing" "com.apple.screensharing.MessagesAgent" 
	"com.apple.screensharing.agent" "com.apple.RemoteDesktop.PrivilegeProxy" 
	"com.apple.RemoteDesktop.agent" "com.apple.blued")
loaded="$(sudo launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"

bad_list=( $(to_remove "${bad[*]}" "$loaded") )

for rmv in "${bad_list[@]}"; do
	e_header "Unloading: $rmv"
	sudo launchctl unload -wF "/System/Library/LaunchDaemons/"$rmv".plist"
done

## Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

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
sudo pmset -a displaysleep 60
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