# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# # Some tools look for XCode, even though they don't need it.
# # https://github.com/joyent/node/issues/3681
# # https://github.com/mxcl/homebrew/issues/10245
# if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
#   sudo xcode-select -switch /usr/bin
# fi

# Homebrew should already be installed at this point.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  
  # Make sure we’re using the latest Homebrew
  brew update

  # Upgrade any already-installed formulae
  brew upgrade

  # Install wget with IRI support
  brew install wget --enable-iri

  # Install more recent versions of some OS X tools
  brew tap homebrew/dupes
  brew install homebrew/dupes/grep
  
  # Install Homebrew recipes.
  recipes=(git ssh-copy-id tree nmap git-extras htop-osx coreutils findutils ack lynx pigz rename tree pkg-config p7zip)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi
  
  echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
  
  # Install wget with IRI support
  e_header "Installing wget with IRI"
  install wget --enable-iri
  
  # Install more recent versions of some OS X tools
  e_header "Install and override latest version of VIM"
  install vim --override-system-vi
  
  #this is needed for the python install below to work
  e_header "Install  readline gdbm sqlite universal"
  brew install readline sqlite gdbm --universal
  
  #update to latest version of python universal == 32/64bit and framework == allows interaction with osx libs
  e_header "Install  readline gdbm sqlite universal"
  brew install python --universal --framework
  
  #install and upgrade PIP
  e_header "Install and Upgrade PIP"
  /usr/local/share/python/easy_install pip
  /usr/local/share/python/pip install --upgrade distribute
  
  e_header "Install VirualENV + VirtualEnvWrapper"
  ##Actually Install VirtualEnv 
  pip install virtualenv 
  pip install virtualenvwrapper
  
  # if [[ ! "$(type -P gcc-4.2)" ]]; then
  #   e_header "Installing Homebrew dupe recipe: apple-gcc42"
  #   brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  # fi
  
  # Install native apps
  brew tap phinze/homebrew-cask
  brew install brew-cask

  function installcask() {
  	brew cask install "${@}" 2> /dev/null
  }
  
  e_header "Install google-chrome"
  brew cask install google-chrome
  
  e_header "Install iterm2"
  brew cask install iterm2
  
  e_header "Install macvim"
  brew cask install macvim
  
  e_header "Install sublime-text"
  brew cask install sublime-text
  
  e_header "Install the-unarchiver"
  brew cask install the-unarchiver
  
  e_header "Install tor-browser"
  brew cask install tor-browser
  
  e_header "Install transmission"
  brew cask install transmission
  
  e_header "Install transmit"
  brew cask install transmit
  
  e_header "Install keepass-x"
  brew cask install keepass-x
  
  e_header "Install x-quartz"
  brew cask install x-quartz
  
  e_header "Install true-crypt"
  brew cask install true-crypt
  
  e_header "Install path-finder"
  brew cask install path-finder
  
  e_header "Install gpgtools"
  brew cask install gpgtools
  
  e_header "Install cord"
  brew cask install cord
  
  e_header "Install adium"
  brew cask install adium
  
  e_header "Install skype"
  brew cask install skype
  
  e_header "Install shuttle"
  brew cask install shuttle
  
  e_header "Install tunnelblick"
  brew cask install tunnelblick
  
  e_header "Install wireshark"
  brew cask install wireshark
  
  e_header "Install little-snitch"
  brew cask install little-snitch
  
  
  # Remove outdated versions from the cellar
  brew cleanup
  
fi

# htop
  if [[ "$(type -P htop)" && "$(stat -L -f "%Su:%Sg" "$(which htop)")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$(which htop)") & 4))" ]]; then
    e_header "Updating htop permissions"
    sudo chown root:wheel "$(which htop)"
    sudo chmod u+s "$(which htop)"
  fi
  
# Setup OXS Config Stugg
source ~/.dotfiles/conf/osx/conf_osx.sh
