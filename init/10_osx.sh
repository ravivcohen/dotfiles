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
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  e_header "Installing Homebrew pks on first run"
fi
echo ~
# Just incase we set the path again over here.
# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$(path_remove /usr/local/bin)
PATH=/usr/local/sbin:$(path_remove /usr/local/sbin)
export PATH

# Fix ZSH permissions
# Safe to run everytime incase of ZSH Update.
sudo chown -R `whoami`:admin /usr/local/Cellar/zsh/


e_header "Brew DR"
brew doctor

e_header "Brew update"
# Make sure we’re using the latest Homebrew
brew update

e_header "Brew upgrade"
#Upgrade any already-installed formulae
brew upgrade

# Tap needed repo's
taps=("homebrew/dupes" "caskroom/cask" "caskroom/versions" "caskroom/fonts")
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

#We need to Patch MUTT for sidebar support
patch -p0 -N --reject-file=/dev/null --dry-run --silent /usr/local/Library/Formula/mutt.rb < $DOTFILES_HOME/.dotfiles/conf/osx/mutt.rb.patch &>/dev/null
#If the patch has not been applied then the $? which is the exit status 
#for last command would have a success status code = 0
if [ $? -eq 0 ];
then
    e_header "Patching Mutt before Brewing"
    #apply the patch
    patch -p0 -N --silent /usr/local/Library/Formula/mutt.rb < $DOTFILES_HOME/.dotfiles/conf/osx/mutt.rb.patch
fi

# Install Homebrew recipes.
recipes=(

apple-gcc42 
"readline --universal" 
"sqlite --universal" 
"gdbm --universal" 
"openssl --universal" 
s-lang
zsh 
"wget --with-iri" 
grep git 
ssh-copy-id  
apg 
nmap
dvtm 
git-extras
htop-osx 
youtube-dl 
coreutils 
findutils 
ack 
lynx 
pigz 
rename 
pkg-config 
p7zip 
"lesspipe --syntax-highlighting"
"python --universal" 
#"macvim --enable-cscope --enable-pythoninterp --custom-icons" #Requires Xcode 
"brew-cask" 
rbenv 
ruby-build 
rbenv-gemset 
rbenv-binstubs 
"aspell --with-lang-en" 
#"weechat -with-aspell --with-perl --with-ruby --with-python" #drops to bash


#--with-ignore-thread-patch Cannot apple with sidebar mutually exclu
"mutt --with-trash-patch --with-s-lang  
--with-pgp-verbose-mime-patch --with-confirm-attachment-patch 
--with-sidebar-patch"
offline-imap
#lbdb #Fails to install  

"vim --with-python --with-ruby --with-perl --enable-cscope 
--enable-pythoninterp --override-system-vi"
)

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
casks=(sublime-text3 iterm2-nightly java6 xquartz tower transmit path-finder adium vagrant keka shuttle)
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
#fonts_dir=$osx_conf_dir/fonts
fonts=(font-dejavu-sans-mono-for-powerline font-inconsolata-dz-for-powerline font-inconsolata-for-powerline
font-inconsolata-g-for-powerline font-meslo-lg-for-powerline font-meslo-lg font-sauce-code-powerline )
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
    brew cask install --fontdir=/Library/Fonts "$font"
  done 
fi
#reset ret
ret=""

if ! grep -q "/usr/local/bin/zsh" "/etc/shells"; then
  e_header "Adding homebrew ZSH to /etc/shells"
  # Add Homebrew Shell to Allowed Shell List
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells > /dev/null
fi

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

# Install Slate
if [[ ! -e "/Applications/Slate.app" ]]; then
  e_header "Installing Slate"
  cd /Applications && curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
fi
# Open Bug HomeBrew 05-25-14
# #install and upgrade PIP
e_header "Install and/Or Upgrade PIP"
pip -q install --upgrade pip
pip -q install --upgrade setuptools
pip -q install --upgrade distribute

# e_header "Install VirualENV + VirtualEnvWrapper"
# ##Actually Install VirtualEnv 
pip -q install --upgrade virtualenv 
pip -q install --upgrade virtualenvwrapper

# if [[ ! "$(type -P gcc-4.2)" ]]; then
#   e_header "Installing Homebrew dupe recipe: apple-gcc42"
#   brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
# fi  

e_header "Brew cleanup"
# Remove outdated versions from the cellar
brew cleanup

e_header "Linking brewed apps"
##link all the apps 
brew linkapps > /dev/null

if [[ ! -e "/Applications/PasswordAssistant.app" ]]; then
  e_header "Setting up PasswordAssistant"
  curl -fsSL https://s3.amazonaws.com/rc_software/PasswordAssistant.zip -o /tmp/PasswordAssistant.zip
  # Remove the PasswordAssitant.app just incase (it might not exist)
  rm -rf "/Applications/PasswordAssistant.app"
  # Link the PasswordAssitant Bin"
  unzip -o -qq /tmp/PasswordAssistant.zip -d /Applications/
  # Begone!
  rm -rf /tmp/PasswordAssistant.zip
fi

# Fix ZSH permissions
# Safe to run everytime incase of ZSH Update.
sudo chown -R root:admin /usr/local/Cellar/zsh/

# DO WE NEED THIS /etc/shelss test if new ZSH is used after install or not
# echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
# chsh -s /usr/local/bin/zsh
# ??
#unalias run-help
#autoload run-help
#HELPDIR=/usr/local/share/zsh/helpfiles

e_header "Running OSX Global Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx_global.sh

