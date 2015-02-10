# I like to use a constant scheme for storing my files:
alias dev="cd $HOME/Development"
alias gigs="cd $HOME/Engagements"
alias tools="cd $HOME/Tools"
alias rcs="cd $HOME/Resources"
alias docs="cd $home/Documents"

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

##Also Fix ll
alias ll='ls -ltrh'
alias lla='ls -altrh'

# # Shortcuts
# alias ll='ls -lh'
# alias la='ls -lhA'
# alias l='ls'
# alias c='clear'
# alias x='exit'
# alias q='exit'
 
# # Don't run shutdown if rtorrent is running - as long as there's a screen with "tor" in its name, shutdown won't run (unless you call /sbin/shutdown, or unalias it)
# alias shutdown='/home/james/scripts/safe.shutdown.sh'
 
# # When using sudo, use alias expansion (otherwise sudo ignores your aliases)
# alias sudo='sudo '

# # Directory listing
# if [[ "$(type -P tree)" ]]; then
#   alias ll='tree --dirsfirst -aLpughDFiC 1'
#   alias lsd='ll -d'
# else
#   alias ll='ls -al'
#   alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
# fi

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}


alias top=htop

# if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
#   export EDITOR='subl -w'
#   export LESSEDIT='subl %f'
#   alias q='subl'
# else
#   export EDITOR=$(type nano pico vi vim 2>/dev/null | sed 's/ .*$//;q')
#   alias q="$EDITOR -w -z"
# fi
# 
# export VISUAL="$EDITOR"
# 
# alias q.='q .'
# 
# function qs() {
#   pwd | perl -ne"s#^$(echo ~/.dotfiles)## && exit 1" && cd ~/.dotfiles
#   q ~/.dotfiles
# }