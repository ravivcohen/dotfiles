[[ "$OSTYPE" =~ ^darwin ]] || return 1

e_header "Running OSX Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx.sh

if [ -d "$DOTFILES_HOME/conf/dotfiles" ]; then
    e_header "Linking CONF files"
    ln -sf $DOTFILES_HOME/conf/dotfiles/* $DOTFILES_HOME/
fi