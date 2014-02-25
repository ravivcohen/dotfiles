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
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/zsh
  
  # Install wget with IRI support
  e_header "Installing wget with IRI"
  brew install wget --enable-iri
  
  
  # Install WireShark
  e_header "Install and override latest version of WireShark with QT"
  brew install wireshark --devel --with-qt
  # Temp fix for wireshark interfaces
  curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
  tar zxvf ChmodBPF.tar.gz
  open ChmodBPF/Install\ ChmodBPF.app

  
  # Install more recent versions of some OS X tools
  brew tap homebrew/dupes
  brew install homebrew/dupes/grep
    
  # Install Homebrew recipes.
  recipes=(git ssh-copy-id tree apg nmap git-extras htop-osx djbdns youtube-dl coreutils findutils ack lynx pigz rename pkg-config p7zip)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi
  
  echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
  
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
  brew install ctags --HEAD

  
  # if [[ ! "$(type -P gcc-4.2)" ]]; then
  #   e_header "Installing Homebrew dupe recipe: apple-gcc42"
  #   brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  # fi
  
  #ToDo install because cask is way to buggy
  # Install native apps [google-chrome, iterm2, macvim, sublime-text, the-unarchiver, tor-browser, transmission, transmit, keepassx, xquartz, truecrypt, path-finder
  # gpgtools, cord, adium, skype, shuttle, tunnelblick-beta, wireshark, vagrant, tower, paragon-ntfs, little-snitch, java, vmware-fusion, ]

  # Remove outdated versions from the cellar
  brew cleanup
  
fi


##link all the apps 
brew linkapps

# htop
if [[ "$(type -P htop)" && "$(stat -L -f "%Su:%Sg" "$(which htop)")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$(which htop)") & 4))" ]]; then
 e_header "Updating htop permissions"
 sudo chown root:wheel "$(which htop)"
 sudo chmod u+s "$(which htop)"
fi



if [[ "$new_dotfiles_install" ]]; then
 e_header "First-Time OSX Init"
 # Terminal
 # ========
 #copy fonts
 cp ~/.dotfiles/conf/osx/powerline-fonts/* /Library/Fonts/
 # # Use a modified version of the Pro theme by default in Terminal.app
 open "link/.oh-my-zsh-custom/terminal/Solarized_Dark_Ver2.terminal"
 sleep 1 # Wait a bit to make sure the theme is loaded
 open "link/.oh-my-zsh-custom/terminal/Solarized_Dark.terminal"
 sleep 1 # Wait a bit to make sure the theme is loade

 # Setup OXS Config Stugg
 source ~/.dotfiles/conf/osx/conf_osx.sh
fi

