[[ "$OSTYPE" =~ ^darwin ]] || return 1

e_header "Running OSX Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx.sh
