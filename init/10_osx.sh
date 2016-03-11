is_osx || return 1

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

# if [[ -d "/usr/local/Cellar/zsh" ]]; then
#   # Fix ZSH permissions
#   # Safe to run everytime incase of ZSH Update.
#   sudo chown -R `whoami`:admin /usr/local/Cellar/zsh/
# fi

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

FALLTHROUGH=
if [[ "$INSTALLTYPE" == "full" ]]; then
  FALLTHROUGH=1
fi


if [[ -n $FALLTHROUGH || "$INSTALLTYPE" == "noxcode" ]]; then
  FALLTHROUGH=1
fi

if [[ -n $FALLTHROUGH || "$INSTALLTYPE" == "minimal" ]]; then
  FALLTHROUGH=1
fi

if [[ -n  $FALLTHROUGH || "$INSTALLTYPE" == "base" ]]; then
  e_header "Running OSX Global Config"
  # OSX Config. Can safely be run everytime.
  source $DOTFILES_HOME/conf/osx/conf_osx_global.sh
fi
