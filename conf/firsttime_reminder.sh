#!/bin/bash
# OSX
  if [[ "$OSTYPE" =~ ^darwin ]]; then
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
	#True-Crypt
	open http://www.truecrypt.org/downloads
	#Paragon
	open http://www.paragon-software.com/home/ntfs-mac/
	#Little-Snitch
	open http://www.obdev.at/products/littlesnitch/download.html
	#google-chrome
	open https://www.google.com/chrome
    
  # Ubuntu.
  elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
  	e_header "TO DO!! "
  fi


