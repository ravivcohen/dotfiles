[[ "$(cat /etc/issue 2> /dev/null)" =~ Arch ]] || return 1

echo "ARCHH"
if [[ "$(whoami)" == "vagrant" ]]; then
    export DISPLAY=:7
fi

# Package management
alias update="sudo pacman --noc -Syyu"
alias install="sudo pacman -S"
alias search="sudo pacman -Ss"

