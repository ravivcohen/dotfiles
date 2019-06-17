
if [[ ! -e $USER_HOME/.oh-my-zsh ]]; then
    # 2. Second We Setup OH-MY-ZSH  
    e_header "Setup oh-my-zsh"
    ##SETUP OH MY ZSH ONLY ON THE FIRST TIME
    chsh -s /bin/zsh
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
