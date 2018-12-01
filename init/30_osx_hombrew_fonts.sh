is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Exit if, for some reason, cask is not installed.
# [[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

# install fonts.
fonts=(
    font-anonymouspro-nerd-font
    font-arimo-nerd-font
    font-codenewroman-nerd-font
    font-cousine-nerd-font
    font-firacode-nerd-font
    font-firamono-nerd-font
    font-go-mono-nerd-font
    font-gohu-nerd-font
    font-hack-nerd-font
    font-hasklig-nerd-font
    font-heavydata-nerd-font
    font-hermit-nerd-font
    font-inconsolata-nerd-font
    font-inconsolatago-nerd-font
    font-inconsolatalgc-nerd-font
    font-iosevka-nerd-font
    font-lekton-nerd-font
    font-meslo-nerd-font
    font-monofur-nerd-font
    font-monoid-nerd-font
    font-mononoki-nerd-font
    font-mplus-nerd-font
    font-profont-nerd-font
    font-proggyclean-nerd-font
    font-sourcecodepro-nerd-font
    font-spacemono-nerd-font
    font-terminus-nerd-font
    font-tinos-nerd-font
    font-ubuntu-nerd-font
 )

fonts=($(setdiff "${fonts[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#fonts[@]} > 0 )); then
  for font in "${fonts[@]}"; do
    e_header "Installing Homebrew recipe: $font"
    brew cask install --fontdir=/Library/Fonts "$font"
  done
  brew cleanup
fi
