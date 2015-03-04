#Burp
burpdirectory="$HOME/Tools/burp/"
logfilename="$(date +%F_%H-%M-%S)"

alias burp='nohup java -jar -Xmx1024m ${burpdirectory}burp.jar >>${burpdirectory}/logs/${logfilename}_stdout.log 2>>${burpdirectory}/logs/${logfilename}_stderr.log &'

###Nikto
alias nikto="perl $HOME/Tools/nikto/nikto.pl"

alias dot="cd $HOME/.dotfiles/"
alias edot="subl $HOME/.dotfiles/"

#load private aliases 
if [[ -e "$HOME/conf/my_aliases_privi.zsh" ]]; then
    source "$HOME/conf/my_aliases_privi.zsh"
fi
