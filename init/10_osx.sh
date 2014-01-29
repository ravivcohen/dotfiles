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
  true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
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
  recipes=(git ssh-copy-id tree nmap git-extras htop-osx coreutils findutils ack lynx pigz rename tree readline sqlite gdbm pkg-config)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi
  
  echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
  
  #update to latest version of python universal == 32/64bit and framework == allows interaction with osx libs
  brew install python --universal --framework
  
  #install and upgrade PIP
  /usr/local/share/python/easy_install pip
  /usr/local/share/python/pip install --upgrade distribute
  
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

  # Install Cask recipes.
  recipes=(google-chrome iterm2 macvim sublime-text the-unarchiver tor-browser transmission transmit keepass-x x-quartz true-crypt path-finder gpgtools cord adium skype shuttle tunnelblick wireshark)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Cask recipes: $list"
    installcask $list
  fi
  
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
