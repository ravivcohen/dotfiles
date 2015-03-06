[[ "$(cat /etc/issue 2> /dev/null)" =~ Arch ]] || return 1

    #All Helper functions can now be found inside libs/helper_functions.
    . $lib_file

    # Update APT.
    e_header "Updating pacman"
    sudo pacman --noc -Syyu

    # Install APT packages.
    packages=(
      zsh
      htop
      python2
    )

    list=()
    for package in "${packages[@]}"; do
      if [[ ! "$(pacman -Q "$package" 2>/dev/null | grep "^$package")" ]]; then
        list=("${list[@]}" "$package")
      fi
    done

    if (( ${#list[@]} > 0 )); then
      e_header "Installing APT packages: ${list[*]}"
      for package in "${list[@]}"; do
        sudo pacman --noc -S "$package"
      done
    fi