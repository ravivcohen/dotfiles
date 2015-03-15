#!/bin/bash

# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

#All Helper functions can now be found inside libs/helper_functions.
. $lib_file

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
[[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

# install fonts.
fonts=(font-dejavu-sans-mono-for-powerline font-inconsolata-dz-for-powerline font-inconsolata-for-powerline
font-inconsolata-g-for-powerline font-meslo-lg-for-powerline font-meslo-lg font-sauce-code-powerline )
fonts=($(setdiff "${fonts[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#fonts[@]} > 0 )); then
  for font in "${fonts[@]}"; do
    e_header "Installing Homebrew recipe: $font"
    brew cask install --fontdir=/Library/Fonts "$font"
  done
  brew cask cleanup
fi
