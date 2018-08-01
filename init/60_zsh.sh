
if [[ ! -e $USER_HOME/.oh-my-zsh ]]; then
    # 2. Second We Setup OH-MY-ZSH  
    e_header "Setup oh-my-zsh"
    ##SETUP OH MY ZSH ONLY ON THE FIRST TIME
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    chsh -s /bin/zsh
fi
