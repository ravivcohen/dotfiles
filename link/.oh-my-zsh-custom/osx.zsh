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

# Add this for Coreutils to be default and overide local
# GNU. 
#PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
#MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# GREP ??

#Some Sudo related stuff if your a STD user.
if [[ $(groups | grep -q -e '\badmin\b')$? -ne 0 ]]; then
    alias sudo="sudo -H -E TMPDIR=/tmp"
    alias rodo="sudo -u root"
fi

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
alias xpra='/Applications/Xpra.app/Contents/Helpers/Xpra'


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
eval `dircolors ~/.oh-my-zsh-custom/dircolors-solarized/dircolors.ansi-dark` 

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

alias passgen="open ~/.dotfiles/bin/PasswordAssistant.app"
#sleepnow - causes an immediate system sleep
#pmset sleepnow
#displaysleepnow - causes display to go to sleep immediately