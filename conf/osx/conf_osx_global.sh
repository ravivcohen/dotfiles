# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
dosu defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Enable HiDPI display modes (requires restart)
dosu defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# It's my library. Let me see it.
dosu chflags nohidden ~/Library/
dosu chflags nohidden /tmp
dosu chflags nohidden /usr

##EXTRAA
# Link to the airport command
dosu ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport

##Security
# Turn on firewall, such as it is
#TODO
#defaults write /Library/Preferences/com.apple.sharing.firewall state -bool YES

# Disable "safe sleep", saving 8-16G of disk space. Doing so is basically no
# less secure than the default behavior when it comes to cold boot attacks, as
# Safe Sleep leaves the RAM powered for hours anyway. You'd have to hibernate
# every time you leave the machine to prevent that. If you want to do that, use
# this:
#
dosu pmset -a destroyfvkeyonstandby 1 hibernatemode 25
#
# You can also use autopoweroff and reduce the autopoweroffdelay if you want 
# to sleep -> hibernate after a period of time.
# pmset -a hibernatemode 0
# pmset -a autopoweroff 0
dosu rm -rf /private/var/vm/sleepimage
#sudo touch /private/var/vm/sleepimage
# sudo chflags uchg /private/var/vm/sleepimage

# Remove the Java browser Plugin.
dosu rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
dosu touch /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
dosu chmod 000 /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
dosu chflags uchg /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
