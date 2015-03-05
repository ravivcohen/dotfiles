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

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

# Just incase we set the path again over here.
# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$(path_remove /usr/local/bin)
PATH=/usr/local/sbin:$(path_remove /usr/local/sbin)
export PATH

# Fix ZSH permissions
# Safe to run everytime incase of ZSH Update.
#sudo chown -R `whoami`:admin /usr/local/Cellar/zsh/


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
"brew-cask" 
"profanity --with-terminal-notifier"

#--with-ignore-thread-patch Cannot apple with sidebar mutually exclu
"wireshark --with-headers --with-libpcap --with-libsmi --with-lua --with-qt --devel"

"vim --with-python --with-ruby --with-perl --enable-cscope 
--enable-pythoninterp --override-system-vi"
)


if [[ $xcode_installed ]]; then
  #We need to Patch MUTT for sidebar support
  patch -p0 -N --reject-file=/dev/null --dry-run --silent /usr/local/Library/Formula/mutt.rb < $DOTFILES_HOME/.dotfiles/conf/osx/mutt.rb.patch &>/dev/null
  #If the patch has not been applied then the $? which is the exit status 
  #for last command would have a success status code = 0
  if [ $? -eq 0 ];  then
    e_header "Patching Mutt before Brewing"
    #apply the patch
    patch -p0 -N --silent /usr/local/Library/Formula/mutt.rb < $DOTFILES_HOME/.dotfiles/conf/osx/mutt.rb.patch
  fi
  recipes+=("mutt --with-trash-patch --with-s-lang  
  --with-pgp-verbose-mime-patch --with-confirm-attachment-patch 
  --with-sidebar-patch"
  offline-imap
  notmuch
  lbdb )
  recipes+=("macvim --enable-cscope --enable-pythoninterp --custom-icons")
fi


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
casks=(sublime-text3 iterm2-nightly firefox java6 tower transmit path-finder adium vagrant keka)
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

# The launch daemon is in the ChmodBPF directory in the source tree. The
# org.wireshark.ChmodBPF.plist file should be copied to the
# /Library/LaunchDaemons directory. It should have the following permissions:

# -rw-r--r-- 1 root wheel 555B Jul 21 00:34 org.wireshark.ChmodBPF.plist

# If you want to give a particular user permission to access the BPF devices,
# rather than giving all administrative users permission to access them, you
# can have the ChmodBPF launch daemon plist change the ownership of /dev/bpf*
# without changing the permissions. If you want to give a particular user
# permission to read and write the BPF devices and give the administrative
# users permission to read but not write the BPF devices, you can have the
# script change the owner to that user, the group to "admin", and the
# permissions to rw-r-----. Other possibilities are left as an exercise for
# the reader.
if [[ "$(stat -Lf "%Sp:%Su:%Sg" /Library/LaunchDaemons/org.wireshark.ChmodBPF.plist)" != "-rw-r--r--:root:wheel" ]]; then
  # # Install WireShark
  # e_header "Install latest version of WireShark with QT"
  # brew install wireshark --devel --with-qt
  # # Temp fix for wireshark interfaces
  curl "https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373" -o /tmp/ChmodBPF.tar.gz
  tar zxvf /tmp/ChmodBPF.tar.gz -C /tmp
  open /tmp/ChmodBPF/Install\ ChmodBPF.app
fi

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

e_header "Running OSX Global Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx_global.sh

