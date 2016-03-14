# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')
    ;;
  'FreeBSD')
    ;;
  'Darwin') 
    export SUBL="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
    ;;
  *) ;;
esac

# Use subl alias to launch Sublime Text
alias subl="subl-wrapper"

# Use nano alias to launch Sublime Text
#alias nano="subl-wrapper"

# Use gedit alias to launch Sublime Text
#alias gedit="subl-wrapper"

# This make svn, git command line commits to use Sublime Text
# for editing commit messages
export EDITOR="subl-wrapper-wait-exit"
