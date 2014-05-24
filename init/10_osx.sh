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
    
    if [[ $is_standard_user ]]; then
      # if your std user echo into admin user path brew
      # this way brew dr wont yell when u run it.
      echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
    fi 
    
  fi
  
  brew doctor
  
  # Make sure we’re using the latest Homebrew
  brew update

  #Upgrade any already-installed formulae
  brew upgrade
  
  # Tap needed repo's
  taps=("homebrew/dupes" "caskroom/cask" "caskroom/versions")
  tap_list=( $(convert_list_to_array "$(brew tap)") )
  to_install "taps[@]" "tap_list[@]"
  
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
  
  # Install Homebrew recipes.
  recipes=(
  "readline --universal" "sqlite --universal" "gdbm --universal" 
  "openssl --universal"
  zsh "wget --enable-iri" grep git ssh-copy-id  apg nmap git-extras
  htop-osx youtube-dl coreutils findutils ack lynx pigz rename 
  pkg-config p7zip "lesspipe --syntax-highlighting"
  "python --universal --framework" 
  "vim --with-python --with-ruby --with-perl --enable-cscope --enable-pythoninterp --override-system-vi"
  "macvim --enable-cscope --enable-pythoninterp --custom-icons" 
  "brew-cask")

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
  
  # Install Casks
  casks=(sublime-text3 iterm2-beta java6 xquartz tower transmit path-finder adium vagrant keka shuttle)
  cask_list=( $(convert_list_to_array "$(brew cask list)") )
  to_install "casks[@]" "cask_list[@]"
  
  # to_install returns Value back to ret
  if [[ "$ret" ]]; then
    # Because brew hard fails incase one application fails.
    # We call each install one by one.
    for cask in "${ret[@]}"
    do
      e_header "Installing Homebrew recipe: $cask"
      brew cask install --appdir="/Applications" $cask
    done 
  fi
  #reset ret
  ret=""
  
  # install fonts.
  osx_conf_dir=$DOTFILES_HOME/.dotfiles/conf/osx
  fonts_dir=$osx_conf_dir/fonts
  fonts=(font-dejavu-sans-mono-for-powerline font-inconsolata-dz-powerline font-inconsolata-powerline
  font-meslo-powerline font-sauce-code-powerline)
  cask_list=( $(convert_list_to_array "$(brew cask list)") )
  to_install "fonts[@]" "cask_list[@]"
  
  # to_install returns Value back to ret
  if [[ "$ret" ]]; then
    # Because brew hard fails incase one application fails.
    # We call each install one by one.
    for font in "${ret[@]}"
    do
      e_header "Installing Homebrew recipe: $font"
      #echo $fonts_dir"/"$font".rb"
      #brew install $recipe
      brew cask install --fontdir=/Library/Fonts $fonts_dir"/"$font".rb"
    done 
  fi
  #reset ret
  ret=""
  
  # Add Homebrew Shell to Allowed Shell List
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
  # Fix ZSH permissions
  sudo chown -R root:admin /usr/local/Cellar/zsh/
  
  # # Install WireShark
  # e_header "Install latest version of WireShark with QT"
  # brew install wireshark --devel --with-qt
  # # Temp fix for wireshark interfaces
  # curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
  # tar zxvf ChmodBPF.tar.gz
  # open ChmodBPF/Install\ ChmodBPF.app
  
  # htop
  if [[ "$(type -P htop)" && "$(stat -L -f "%Su:%Sg" "$(which htop)")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$(which htop)") & 4))" ]]; then
    e_header "Updating htop permissions"
    sudo chown root:wheel "$(which htop)"
    sudo chmod u+s "$(which htop)"
  fi

  
  #install and upgrade PIP
  e_header "Install and Upgrade PIP"
  pip install --upgrade setuptools
  pip install --upgrade pip
  pip install --upgrade distribute
  
  e_header "Install VirualENV + VirtualEnvWrapper"
  ##Actually Install VirtualEnv 
  pip install virtualenv 
  pip install virtualenvwrapper

  # if [[ ! "$(type -P gcc-4.2)" ]]; then
  #   e_header "Installing Homebrew dupe recipe: apple-gcc42"
  #   brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  # fi  
  
  # Remove outdated versions from the cellar
  brew cleanup

  e_header "Linking brewed apps"
  ##link all the apps 
  brew linkapps

  if [[ ! -L "/Applications/PasswordAssistant.app" ]]; then
    e_header "Linking PasswordAssistant"
    # Remove the PasswordAssitant.app just incase (it might not exist)
    rm -rf "/Applications/PasswordAssistant.app"
    # Link the PasswordAssitant Bin"
    ln -s $DOTFILES_HOME/.dotfiles/bin/PasswordAssistant.app /Applications/PasswordAssistant.app
  fi
  
  
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

