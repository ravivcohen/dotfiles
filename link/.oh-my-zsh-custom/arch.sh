# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Arch ]] || return 1

# Package management
alias update="sudo pacman --noc -Syyu"
alias install="sudo pacman -S"
alias search="sudo pacman -Ss"

