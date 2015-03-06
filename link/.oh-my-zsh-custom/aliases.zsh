#load aliasxs 
if [[ -e "$HOME/.my_aliasxs.zsh" ]]; then
    source "$HOME/.my_aliasxs.zsh"
fi

export lDOTFILES="$HOME/.dotfiles"
# Add binaries into the path
PATH=~/.dotfiles/bin:$PATH
export PATH

# Run dotfiles script, then source.
function dotfiles() {
  ~/.dotfiles/bin/dotfiles "$@"
}
alias dot="cd $HOME/.dotfiles/"


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
alias la='ls -lhA'
alias l='ls'
alias c='clear'
alias x='exit'
alias q='exit'
 
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

# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"


# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Update Burp
alias uburp='python $HOME/.dotfiles/bin/burp_download'
