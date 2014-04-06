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
  
  # Install wget with IRI support
  e_header "Installing wget with IRI"
  brew install wget --enable-iri
  
  
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
  
  #ToDo install because cask is way to buggy
  # Install native apps [google-chrome, iterm2, macvim, sublime-text, the-unarchiver, tor-browser, transmission, transmit, keepassx, xquartz, truecrypt, path-finder
  # gpgtools, cord, adium, skype, shuttle, tunnelblick-beta, wireshark, vagrant, tower, paragon-ntfs, little-snitch, java, vmware-fusion, ]

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

