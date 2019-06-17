is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
# [[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

# install fonts.
fonts=(
    font-hack-nerd-font
    font-sourcecodepro-nerd-font
 )

fonts=($(setdiff "${fonts[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#fonts[@]} > 0 )); then
  for font in "${fonts[@]}"; do
    e_header "Installing Homebrew recipe: $font"
    brew cask install --fontdir=/Library/Fonts "$font"
  done
  brew cleanup
fi
