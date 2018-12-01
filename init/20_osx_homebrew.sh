is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1


# Install Homebrew recipes.
recipes=(
  openssl
  gdbm
  python
  python@2
  "--HEAD universal-ctags"
  youtube-dl
  ssh-copy-id
  git  
  git-extras
  htop-osx
  ack
  pcre 
  rename 
  p7zip 
  "lesspipe --with-syntax-highlighting"
  macvim
  zsh 
  wget
  "nmap --with-pygtk"
  coreutils
)

export PATH="/usr/local/bin:$PATH"

unset setdiffA setdiffB setdiffC;
setdiffA=("${recipes[@]}"); setdiffB=( $(brew list) ); setdiff
# Because brew hard fails incase one application fails.
# We call each install one by one.
for recipe in "${setdiffC[@]}"
do
  e_header "Installing Homebrew recipe: $recipe"
  brew install $recipe
done 


################################################################################
# POST INSTALL CONFIG                                                          #
################################################################################

# This is where brew stores its binary symlinks
brewroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"
binroot=$brewroot/bin
cellarroot=$brewroot/Cellar

# Install Slate
if [[ ! -e "/Applications/Slate.app" ]]; then
  e_header "Installing Slate"
  cd /Applications 
  curl https://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
fi

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

if [[ "$(type -P pip)" ]]; then
  e_header "Install and/Or Upgrade PIP"
  pip install --upgrade pip
  pip install --upgrade setuptools
  pip install --upgrade distribute
  pip install --upgrade virtualenv 
  pip install --upgrade virtualenvwrapper
fi

# ZSH
if [[ "$(type -P $binroot/zsh)" ]]; then
  if ! grep -q "$binroot/zsh" "/etc/shells"; then
    e_header "Adding $binroot/zsh to the list of acceptable shells"
    echo "$binroot/zsh" | sudo tee -a /etc/shells >/dev/null
  fi
fi
 
e_header "Brew cleanup"
# Remove outdated versions from the cellar
brew cleanup
