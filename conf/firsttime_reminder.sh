#!/usr/bin/env bash

# OSX
  if [[ is_osx ]]; then
  	open -a Safari
  	sleep 1
	#tunnelblick-beta
	open https://code.google.com/p/tunnelblick/wiki/DownloadsEntry#Tunnelblick_Beta_Release
	#gpgtools
	open https://gpgtools.org/
	#vmware-fusion
	open https://my.vmware.com/web/vmware/login
	#keepassx
	open https://www.keepassx.org/dev/projects/keepassx/files
	#Paragon
	open https://www.paragon-software.com/home/ntfs-mac/
	#Little-Snitch
	open https://www.obdev.at/products/littlesnitch/download.html
	#google-chrome
	open https://www.google.com/chrome
    #VB box
    open https://www.virtualbox.org/wiki/Downloads
    #xPRA
    https://www.xpra.org/
    
  # Ubuntu.
  elif [[ is_ubuntu ]]; then
  	e_header "TO DO!! "
  fi


