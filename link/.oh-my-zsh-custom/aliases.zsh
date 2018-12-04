export DOTFILES="$HOME/.dotfiles"
# Add binaries into the path
PATH=~/.dotfiles/bin:$PATH
export PATH

# Run dotfiles script, then source.
function dotfiles() {
  ~/.dotfiles/bin/dotfiles "$@"
}
alias dot="cd $HOME/.dotfiles/"

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

##Also Fix ll
alias ll='ls -ltrh'
alias la='ls -altrh'
alias l='ls'
alias c='clear'
alias x='exit'
alias q='exit'
 
# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

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

# Sort IPs
alias sip='sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'

#load aliasxs 
if [[ -e "$HOME/.my_aliases" ]]; then
    source "$HOME/.my_aliases"
fi
