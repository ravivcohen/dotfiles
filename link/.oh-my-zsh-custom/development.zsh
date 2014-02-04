# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"


# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""


# OSX
if [[ "$OSTYPE" =~ ^darwin ]]; then
    ##Python and virtual ENVS Stuff!!
    # PATH=/usr/local/share/python/:$PATH
    # export WORKON_HOME=~/.virtualenvs
    # source /usr/local/share/python/virtualenvwrapper.sh
    # export PIP_VIRTUALENV_BASE=$WORKON_HOME
    # export PIP_RESPECT_VIRTUALENV=true

    # Python
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


# Ubuntu.
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
  # Git is fairly easy.
  e_header "Installing Git"
  sudo apt-get -qq install git-core
fi



