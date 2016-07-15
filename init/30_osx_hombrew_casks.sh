is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
# [[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

casks=()
FALLTHROUGH=
if [[ "$INSTALLTYPE" == "full" ]]; then
  FALLTHROUGH=1
  casks+=(vagrant)
fi

if [[ -n $FALLTHROUGH || "$INSTALLTYPE" == "noxcode" ]]; then
  FALLTHROUGH=1
  casks+=(tower transmit path-finder adium)
fi

if [[ -n $FALLTHROUGH || "$INSTALLTYPE" == "minimal" ]]; then
  FALLTHROUGH=1
  casks+=(firefox java6 keka)
fi

if [[ -n $FALLTHROUGH || "$INSTALLTYPE" == "base" ]]; then
    casks+=(sublime-text iterm2-nightly)
fi

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  for cask in "${casks[@]}"; do
    e_header "Installing Homebrew recipe: $cask"
    brew cask install --appdir="/Applications" $cask
  done
  brew cask cleanup
fi
