#!/bin/bash

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1
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

if [[ -d "/usr/local/Cellar/zsh" ]]; then
  # Fix ZSH permissions
  # Safe to run everytime incase of ZSH Update.
  sudo chown -R `whoami`:admin /usr/local/Cellar/zsh/
fi

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
taps=($(setdiff "${taps[*]}" "$(brew tap)"))
if (( ${#taps[@]} > 0 )); then
  for a_tap in "${taps[@]}"; do
    e_header "Tapping Homebrew: $a_tap"
    brew tap $a_tap
  done
fi

if [ -z "$not_personal" ]; then

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

fi

e_header "Running OSX Global Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx_global.sh

