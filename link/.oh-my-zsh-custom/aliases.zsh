#Burp
burpdirectory="$HOME/Tools/burp/"
logfilename="$(date +%F_%H-%M-%S)"

alias burp='nohup java -jar -Xmx1024m ${burpdirectory}burp.jar >>${burpdirectory}/logs/${logfilename}_stdout.log 2>>${burpdirectory}/logs/${logfilename}_stderr.log &'

###firefox
alias firefox='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin -p > /dev/null 2>&1 &'

###Nikto
alias nikto="perl $HOME/Tools/nikto/nikto.pl"

alias dotfiles="cd $HOME/.dotfiles/"
alias edotfiles="subl $HOME/.dotfiles/"

#load private aliases 
if [[ -e "$HOME/conf/my_aliases_privi.zsh" ]]; then
    source "$HOME/conf/my_aliases_privi.zsh"
fi
