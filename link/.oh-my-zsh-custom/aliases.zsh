##This should work if not alias this.!
dev=~/Development
projects=~/Development/isec/projects
tools=~/Development/isec/tools

#Burp
burpdirectory="$HOME/Tools/burp/"
logfilename="$(date +%F_%H-%M-%S)"

alias burp='nohup java -jar -Xmx1024m ${burpdirectory}burp.jar >>${burpdirectory}/logs/${logfilename}_stdout.log 2>>${burpdirectory}/logs/${logfilename}_stderr.log &'

###firefox
alias firefox='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin -p > /dev/null 2>&1 &'
