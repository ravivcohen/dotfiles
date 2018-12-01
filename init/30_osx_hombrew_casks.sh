is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
# [[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

casks=(transmit adium wireshark firefox keka sublime-text google-chrome tunnelblick xpra alfred iterm2)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  for cask in "${casks[@]}"; do
    e_header "Installing Homebrew recipe: $cask"
    brew cask install --appdir="/Applications" $cask
  done
  brew cleanup
fi
