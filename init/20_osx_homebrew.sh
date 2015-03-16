#!/bin/bash

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

#All Helper functions can now be found inside libs/helper_functions.
#. $lib_file

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1


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
grep 
git 
ssh-copy-id  
nmap
git-extras
htop-osx  
coreutils 
findutils 
ack 
lynx 
rename 
pkg-config 
p7zip 
"lesspipe --syntax-highlighting"
"python --universal" 
"brew-cask"
#--with-ignore-thread-patch Cannot apple with sidebar mutually exclu
"wireshark --with-headers --with-libpcap --with-libsmi --with-lua --with-qt --devel"

"vim --with-python --with-ruby --with-perl --enable-cscope 
--enable-pythoninterp --override-system-vi"
)

if [ -z "$not_personal" ]; then
  recipes+=("profanity --with-terminal-notifier" dvtm youtube-dl)

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
    urlview
    lbdb )
  fi
fi

# unset setdiffA setdiffB setdiffC;
# setdiffA=("${recipes[@]}"); setdiffB=( $(brew list) ); setdiff
# # Because brew hard fails incase one application fails.
# # We call each install one by one.
# for recipe in "${setdiffC[@]}"
# do
#   e_header "Installing Homebrew recipe: $recipe"
#   brew install $recipe
# done 

# This is where brew stores its binary symlinks
binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin


if ! grep -q "$binroot/zsh" "/etc/shells"; then
  e_header "Adding homebrew ZSH to /etc/shells"
  # Add Homebrew Shell to Allowed Shell List
  echo "$binroot/zsh" | sudo tee -a /etc/shells > /dev/null
fi

if [[ -d "$binroot/zsh" ]]; then
  # Fix ZSH permissions
  # Safe to run everytime incase of ZSH Update.
  sudo chown -R root:admin $binroot/zsh/
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
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# Install Slate
if [[ ! -e "/Applications/Slate.app" ]]; then
  e_header "Installing Slate"
  cd /Applications && curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
fi

if [[ "$(type -P pip)" ]]; then
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

fi

e_header "Brew cleanup"
# Remove outdated versions from the cellar
brew cleanup

e_header "Linking brewed apps"
##link all the apps 
brew linkapps > /dev/null

