# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Utilities, helpers. Moved into here just to make it cleaner
# From http://stackoverflow.com//370047/#370255
function path_remove() {
  IFS=:
  # convert it to an array
  t=($PATH)
  unset IFS
  # perform any array operations to remove elements from the array
  t=(${t[@]%%$1})
  IFS=:
  # output the new array
  echo "${t[*]}"
}

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$(path_remove /usr/local/bin)
PATH=/usr/local/sbin:$(path_remove /usr/local/sbin)
export PATH

#Some Sudo related stuff if your a STD user.
if [[ $(groups | grep -q -e '\badmin\b')$? -ne 0 ]]; then
    alias sudo="sudo -H -E TMPDIR=/tmp"
    alias rodo="sudo -u root"
fi

###firefox
alias firefox='nohup /Applications/Firefox.app/Contents/MacOS/firefox-bin -p > /dev/null 2>&1 &'


alias xpra='/Applications/Xpra.app/Contents/Helpers/Xpra'
#XPRA Vagrant Stuff
#so i can do something like
#vagrant-xpra ssh:
#vagrant-xpra webapp ssh:
#whatever vm name im using
vagrant-xpra () { 
  if [ $# -le 1 ]; then 
    xpra attach --encoding=rgb --no-microphone --no-speaker --ssh="vagrant ssh -- " ${@:1}
  else 
    xpra attach --encoding=rgb --no-microphone --no-speaker --ssh="vagrant ssh $1 -- " ${@:2} 
  fi 
}

#xpra attach --encoding=h264 --quality=75 --no-microphone --no-speaker --opengl=yes  --dpi=72 --ssh="vagrant ssh webapp -- " ssh:2

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

if which gls &> /dev/null; then
	alias ls='gls --color=auto'
else
	alias ls='ls -G'
fi

##Setup DirColors DB to load on start
alias dircolors='gdircolors'
eval `dircolors ~/.oh-my-zsh-custom/dircolors-solarized/dircolors.256dark` 

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

alias passgen="open ~/.dotfiles/bin/PasswordAssistant.app"

# Python
# No longer needed!
#PATH=/usr/local/share/python/:$PATH
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
else
    echo "WARNING: Can't find virtualenvwrapper.sh"
fi

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

#Burp
burpdirectory="$HOME/Tools/burp/"
logfilename="$(date +%F_%H-%M-%S)"

alias burp='nohup java -jar -Xmx1024m ${burpdirectory}burp.jar >>${burpdirectory}/logs/${logfilename}_stdout.log 2>>${burpdirectory}/logs/${logfilename}_stderr.log &'

alias edot="subl $HOME/.dotfiles/"

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin::/usr/local/MacGPG2/bin
export PATH=/usr/texbin:$PATH
# Brew ZSH requires this
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

