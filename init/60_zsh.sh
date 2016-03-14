
if [[ ! -e $USER_HOME/.oh-my-zsh ]]; then
    # 2. Second We Setup OH-MY-ZSH  
    e_header "Setup oh-my-zsh"
    ##SETUP OH MY ZSH ONLY ON THE FIRST TIME
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if is_arch; then
    #TODO
    if [[ $(whoami) == "vagrant" ]]; then
        sudo chsh -s "$(which zsh)" vagrant
    fi
fi
