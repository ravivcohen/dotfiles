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
if [[ "$new_dotfiles_install" ]]; then
  if [[ ! "$(type -P brew)" ]]; then
    e_header "Installing Homebrew"
    true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    e_header "Installing Homebrew pks on first run"
  fi

  brew doctor
  
  # Make sure we’re using the latest Homebrew
  brew update

  #Upgrade any already-installed formulae
  brew upgrade
  
  # #this is needed for the python install below to work
  # e_header "Install  readline gdbm sqlite universal"
  # brew install readline sqlite gdbm --universal
  
  # e_header "Installing ZSH"
  # brew install zsh
  # # Add Homebrew Shell to Allowed Shell List
  # echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
  # # Fix permissions
  # sudo chown -R root:admin /usr/local/Cellar/zsh/
  
  # Install wget with IRI support
  #e_header "Installing wget with IRI"
  #brew install wget --enable-iri
  
  
  # # Install WireShark
  # e_header "Install latest version of WireShark with QT"
  # brew install wireshark --devel --with-qt
  # # Temp fix for wireshark interfaces
  # curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
  # tar zxvf ChmodBPF.tar.gz
  # open ChmodBPF/Install\ ChmodBPF.app
  
  # Install more recent versions of some OS X tools
  taps=("homebrew/dupes" "caskroom/cask")
  tap_list=( $(convert_list_to_array "$(brew tap)") )
  to_install "taps[@]" "tap_list[@]"
  #brew tap homebrew/dupes
  # to_install returns Value back to ret
  if [[ "$ret" ]]; then
    # Because brew hard fails incase one application fails.
    # We call each install one by one.
    for a_tap in "${ret[@]}"
    do
      e_header "Tapping Homebrew: $recipe"
      brew tap $a_tap
    done 
  fi
  #reset ret
  ret=""
  

  #brew install homebrew/dupes/grep
      
  # Install Homebrew recipes.
  recipes=("readline --universal" "sqlite --universal" "gdbm --universal" zsh
    "wget --enable-iri" grep git ssh-copy-id  apg nmap git-extras
    htop-osx youtube-dl coreutils findutils ack lynx pigz rename pkg-config p7zip "lesspipe --syntax-highlighting"
    "python --universal --framework" "vim --with-python --with-ruby --with-perl --enable-cscope --enable-pythoninterp --override-system-vi"
    "macvim --enable-cscope --enable-pythoninterp --custom-icons" "brew-cask")

  brew_list=( $(convert_list_to_array "$(brew list)") )
  to_install "recipes[@]" "brew_list[@]"
  
  # to_install returns Value back to ret
  if [[ "$ret" ]]; then
    # Because brew hard fails incase one application fails.
    # We call each install one by one.
    for recipe in "${ret[@]}"
    do
      e_header "Installing Homebrew recipe: $recipe"
      brew install $recipe
    done 
  fi
  #reset ret
  ret=""
  exit

  echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
  
  # htop
  if [[ "$(type -P htop)" && "$(stat -L -f "%Su:%Sg" "$(which htop)")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$(which htop)") & 4))" ]]; then
    e_header "Updating htop permissions"
    sudo chown root:wheel "$(which htop)"
    sudo chmod u+s "$(which htop)"
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

  # Link the PasswordAssitant Bin"
  ln -sF $DOTFILES_HOME/.dotfiles/bin/PasswordAssistant.app /Applications/PasswordAssistant.app

  
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

