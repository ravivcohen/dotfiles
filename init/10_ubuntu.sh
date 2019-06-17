is_ubuntu || return 1

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq upgrade

# Install APT packages.
packages=(
  build-essential
  git-core
  nmap
  htop
  ack-grep
  git-extras
  zsh
)

list=()
for package in "${packages[@]}"; do
  if [[ ! "$(dpkg -l "$package" 2>/dev/null | grep "^ii  $package")" ]]; then
    list=("${list[@]}" "$package")
  fi
done

if (( ${#list[@]} > 0 )); then
  e_header "Installing APT packages: ${list[*]}"
  for package in "${list[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi
