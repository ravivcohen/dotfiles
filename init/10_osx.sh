#!/bin/bash

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# # Some tools look for XCode, even though they don't need it.
# # https://github.com/joyent/node/issues/3681
# # https://github.com/mxcl/homebrew/issues/10245
# if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
#   sudo xcode-select -switch /usr/bin
# fi

#All Helper functions can now be found inside libs/helper_functions.
. $lib_file

# Homebrew should already be installed at this point.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  e_header "Installing Homebrew pks on first run"
  
  brew doctor
  
  # Make sure we’re using the latest Homebrew
  brew update

  # Upgrade any already-installed formulae
  brew upgrade
  
  #this is needed for the python install below to work
  e_header "Install  readline gdbm sqlite universal"
  brew install readline sqlite gdbm --universal
  
  e_header "Installing ZSH"
  brew install zsh
  # Add Homebrew Shell to Allowed Shell List
  echo "/usr/local/bin/zsh" | dosu tee -a /etc/shells
  # Fix permissions
  dosu chown -R root:admin /usr/local/Cellar/zsh/
  #dosu chown -R root:admin /usr/local/share/zsh/

  # Install wget with IRI support
  e_header "Installing wget with IRI"
  brew install wget --enable-iri
  
#     zpython.rb  zpython: use checksummed patches  20 days ago
# zsh-completions.rb  zsh-completions 0.10.0  8 months ago
# zsh-history-substring-search.rb zsh-history-substring-search 1.0.0  5 months ago
# zsh-lovers.rb zsh-lovers: style nits  a year ago
# zsh-syntax-highlighting.rb  zsh-syntax-highlighting 0.2.0 8 months ago
# zsh.rb  Batch convert http download urls from SourceForge to https  a month ago
# zshdb.rb  Batch convert http download urls from SourceForge to https  a month ago
# zssh.rb Batch convert http download urls from SourceForge to https  a month ago
# zsync.rb  Batch convert MD5 formula to SHA1.  2 years ago
# zxcc.rb zxcc 0.5.7  3 months ago
# zzuf.rb
  
  # # Install WireShark
  # e_header "Install latest version of WireShark with QT"
  # brew install wireshark --devel --with-qt
  # # Temp fix for wireshark interfaces
  # curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
  # tar zxvf ChmodBPF.tar.gz
  # open ChmodBPF/Install\ ChmodBPF.app

  
  # Install more recent versions of some OS X tools
  brew tap homebrew/dupes
  brew install homebrew/dupes/grep
    
  # Install Homebrew recipes.
  recipes=(git ssh-copy-id tree apg nmap git-extras htop-osx youtube-dl coreutils findutils ack lynx pigz rename pkg-config p7zip)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi
  
  echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
  
  # htop
  if [[ "$(type -P htop)" && "$(stat -L -f "%Su:%Sg" "$(which htop)")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$(which htop)") & 4))" ]]; then
    e_header "Updating htop permissions"
    dosu chown root:wheel "$(which htop)"
    dosu chmod u+s "$(which htop)"
  fi

  e_header "Install Less PIPE"
  brew install lesspipe --syntax-highlighting

  #update to latest version of python universal == 32/64bit and framework == allows interaction with osx libs
  e_header "Install  python universal"
  brew install python --universal --framework
  
  # Temp fix for pip. https://github.com/Homebrew/homebrew/pull/28196
  #ln -s $(brew --prefix)/Cellar/python/2.7.6/bin/pip $(brew --prefix)/bin/pip
  
  #install and upgrade PIP
  e_header "Install and Upgrade PIP"
  pip install --upgrade setuptools
  pip install --upgrade pip
  pip install --upgrade distribute
  
  e_header "Install VirualENV + VirtualEnvWrapper"
  ##Actually Install VirtualEnv 
  pip install virtualenv 
  pip install virtualenvwrapper

  # Install more recent versions of some OS X tools
  e_header "Install and override latest version of VIM + MacVim"

  brew install vim --with-python --with-ruby --with-perl --enable-cscope --enable-pythoninterp --override-system-vi
  brew install macvim --enable-cscope --enable-pythoninterp --custom-icons
  # CERT Check Fails. Dont like that removing for now.
  #brew install ctags --HEAD

  # if [[ ! "$(type -P gcc-4.2)" ]]; then
  #   e_header "Installing Homebrew dupe recipe: apple-gcc42"
  #   brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  # fi
  
  ## OK Lets use cask to install some basic stuff since it is *VERY* !! Buggy
  brew tap phinze/cask
  brew install brew-cask
  # Tap to allow us to install Sublime Text 3
  brew tap caskroom/versions
  # Change so all casks are installed in the main apps folder.
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"

  #Ok Lets install sublime text
  brew cask install sublime-text3
  
  brew cask install $DOTFILES_HOME/.dotfiles/conf/osx/iterm2.rb
  brew cask install java6
  brew cask install xquartz
  brew cask install tower
  brew cask install transmit
  brew cask install path-finder
  brew cask install adium
  brew cask install vagrant
  brew cask install keka
  brew cask install shuttle
  
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

  
  # Get fonts.
  osx_conf_dir=$DOTFILES_HOME/.dotfiles/conf/osx
  fonts_dir=$osx_conf_dir/fonts
  for f in $fonts_dir/*.rb
  do
    brew cask install --fontdir=/Library/Fonts --force $f
  done


  # Remove outdated versions from the cellar
  brew cleanup

  ##link all the apps 
  brew linkapps

  
else  
  e_header "Updating Homebrew"

  brew doctor
  
  # Make sure we’re using the latest Homebrew
  brew update

  # Upgrade any already-installed formulae
  brew upgrade
fi


# DO WE NEED THIS /etc/shelss test if new ZSH is used after install or not
# echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
# chsh -s /usr/local/bin/zsh
# ??
#unalias run-help
#autoload run-help
#HELPDIR=/usr/local/share/zsh/helpfiles


# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx_global.sh

