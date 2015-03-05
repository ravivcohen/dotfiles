[[ "$OSTYPE" =~ ^darwin ]] || return 1

e_header "Running OSX Config"
# OSX Config. Can safely be run everytime.
source $DOTFILES_HOME/.dotfiles/conf/osx/conf_osx.sh

if [ -d "$DOTFILES_HOME/conf/dotfiles" ]; then
    e_header "Linking CONF files"
    ln -s $DOTFILES_HOME/conf/dotfiles/.* $DOTFILES_HOME/ 2>/dev/null
fi

# After we fixed the perms we need to re init ZSH
rm ~/.zcompdump*
zsh -c "autoload -U compinit; compinit -i"