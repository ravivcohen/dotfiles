##This should work if not alias this.!
dev=~/Development
projects=~/Development/isec/projects
tools=~/Development/isec/tools

#Burp
burpdirectory="$HOME/Development/iSec_Tools/Burp/"
logfilename="$(date +%F_%H-%M-%S)"

alias burp='nohup java -jar -Xmx1024m ${burpdirectory}burpsuite_pro.jar >>${burpdirectory}/logs/${logfilename}_stdout.log 2>>${burpdirectory}/logs/${logfilename}_stderr.log &'

###firefox
alias firefox='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin -p > /dev/null 2>&1 &'


#more more cowbell
#alias cowbell='ssh root@moremorecowbell.isecpartners.com -p 19242'