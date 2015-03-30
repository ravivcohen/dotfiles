is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1


# Install Homebrew recipes.
recipes=(
  ctags 
  "readline --universal" 
  "sqlite --universal" 
  "gdbm --universal" 
  "openssl --universal" 
  s-lang
  zsh 
  "wget --with-iri" 
  grep 
  git 
  ssh-copy-id  
  git-extras
  htop-osx  
  coreutils 
  findutils 
  ack 
  rename 
  p7zip 
  "lesspipe --syntax-highlighting"
  "python --universal" 
  "brew-cask"
  "vim --with-python --with-ruby --with-perl --enable-cscope 
  --enable-pythoninterp --override-system-vi"
)

if [ -z "$not_personal" ]; then
  recipes+=(
  apple-gcc42
  nmap
  lynx 
  pkg-config 
  "wireshark --with-headers --with-libpcap --with-libsmi --with-lua --with-qt --devel"
  "profanity --with-terminal-notifier"
  dvtm
  youtube-dl
  awscli
  )

  if [[ $xcode_installed ]]; then
    #We need to Patch MUTT for sidebar support
    patch -p0 -N --reject-file=/dev/null --dry-run --silent /usr/local/Library/Formula/mutt.rb < $DOTFILES_HOME/conf/osx/mutt.rb.patch &>/dev/null
    #If the patch has not been applied then the $? which is the exit status 
    #for last command would have a success status code = 0
    if [ $? -eq 0 ];  then
      e_header "Patching Mutt before Brewing"
      #apply the patch
      patch -p0 -N --silent /usr/local/Library/Formula/mutt.rb < $DOTFILES_HOME/conf/osx/mutt.rb.patch
    fi

    recipes+=("mutt --with-trash-patch --with-s-lang  
    --with-pgp-verbose-mime-patch --with-confirm-attachment-patch 
    --with-sidebar-patch"
    offline-imap
    notmuch
    urlview
    lbdb )
  fi
fi

unset setdiffA setdiffB setdiffC;
setdiffA=("${recipes[@]}"); setdiffB=( $(brew list) ); setdiff
# Because brew hard fails incase one application fails.
# We call each install one by one.
for recipe in "${setdiffC[@]}"
do
  e_header "Installing Homebrew recipe: $recipe"
  brew install $recipe
done 

# This is where brew stores its binary symlinks
brewroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"
binroot=$brewroot/bin
cellarroot=$brewroot/Cellar

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# ZSH
if [[ "$(type -P $binroot/zsh)" && "$(cat /etc/shells | grep -q "$binroot/zsh")" ]]; then
  e_header "Adding $binroot/zsh to the list of acceptable shells"
  echo "$binroot/zsh" | sudo tee -a /etc/shells >/dev/null
fi


# -rw-r--r-- 1 root wheel
if [[ "$(stat -L -f "%Sp:%Su:%Sg" /Library/LaunchDaemons/org.wireshark.ChmodBPF.plist)" != "-rw-r--r--:root:wheel" ]]; then
  # # Temp fix for wireshark interfaces
  curl "https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373" -o /tmp/ChmodBPF.tar.gz
  tar zxvf /tmp/ChmodBPF.tar.gz -C /tmp
  open /tmp/ChmodBPF/Install\ ChmodBPF.app
fi

# Install Slate
if [[ ! -e "/Applications/Slate.app" ]]; then
  e_header "Installing Slate"
  cd /Applications && curl https://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
fi

if [[ "$(type -P pip)" ]]; then
  e_header "Install and/Or Upgrade PIP"
  pip -q install --upgrade pip
  pip -q install --upgrade setuptools
  pip -q install --upgrade distribute

  pip -q install --upgrade virtualenv 
  pip -q install --upgrade virtualenvwrapper

fi

e_header "Brew cleanup"
# Remove outdated versions from the cellar
brew cleanup

e_header "Linking brewed apps"
##link all the apps 
brew linkapps > /dev/null

