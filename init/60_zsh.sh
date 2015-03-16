#All Helper functions can now be found inside libs/helper_functions.
#. $lib_file


if [[ ! -e $HOME/.oh-my-zsh ]]; then
    # 2. Second We Setup OH-MY-ZSH  
    e_header "Setup oh-my-zsh"
    ##SETUP OH MY ZSH ONLY ON THE FIRST TIME
    curl -L http://install.ohmyz.sh | sh
fi

if [[ "$(cat /etc/issue 2> /dev/null)" =~ Arch ]]; then
    #TODO
    if [[ $(whoami) == "vagrant" ]]; then
        sudo chsh -s "$(which zsh)" vagrant
    fi
fi
