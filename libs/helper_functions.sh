#!/bin/bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m➜\033[0m  $@"; }

ret=""

function check_sudo() {
  if [[ $(sudo -u root whoami) != "root" ]]; then
    e_error "Sorry, you need root to run parts of this script exiting."
    # Ask to setup /etc/sudoers
    read -p '''1. Yes, as runaspw
    2. Yes, as targetpw
    3. No
    Do you need to setup /etc/sudoers ?  
    ''' yn
    case $yn in
    [1]* ) 
      read -p "Enter the username to use:" username
      read -p "Enter the group to use:" groupname
      su $username -m -c "echo 'Defaults:%$groupname runas_default=$username, runaspw' | sudo tee -a /etc/sudoers;
      echo '%$groupname ALL=(ALL) ALL' | sudo tee -a /etc/sudoers"
      ;;
    [2]* )
      read -p "Enter the group to use:" groupname
      su -m -c "echo 'Defaults:%$groupname targetpw' >> /etc/sudoers; 
      echo '%$groupname ALL=(ALL) ALL' >> /etc/sudoers"
      ;;
    * ) e_error "Skipping /etc/sudoers setup"
        exit 1 
        ;;
    esac
    if [[ $(sudo -u root whoami) != "root" ]]; then
      e_error "Sorry, you need root to run parts of this script exiting."
      exit 1
    fi
    
  fi

}

function check_cmd_tools() {
  pkgutil --pkg-info=com.apple.pkg.CLTools_Executables >/dev/null 2>&1
  # Ensure that we can actually, like, compile anything.
  # If XCode CLI Tools aren't installed
  # We assume if not CLI tools clean install and update the whole system
  if [[ $? != 0 ]]; then
    e_header "Installing XCode Command Line Tools and All Updates"
    # create the placeholder file that's checked by CLI updates' .dist code
    # in Apple's SUS catalog
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    # install all the updates
    # Find the last listed update in the Software Update feed with "Command Line Tools" in the name
    cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | tail -1 | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
    #Install the command line tools
    softwareupdate -i "$cmd_line_tools" -v
    # Remove the temp file
    if [[ -f "/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress" ]]; then
      rm -rf "/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
    fi
    # Install the rest of the updated
    softwareupdate -iav
    e_header "Must Reboot Damn you Apple"
    # This creates a .profile and will continue the install upon reboot.
    # This works because:
    # a. On a clean install before any mods upon issuing sudo reboot the terminal reopens as part of restore previous state
    # b. One a clean install .profile does not exist so it easy to manipulate and later delete.
    echo 'bash -c "$(curl -fsSL https://raw.github.com/ravivcohen/dotfiles/master/bin/dotfiles)"' >> .profile
    sleep 5
    sudo -u root reboot
  fi
}


# Initialize.
function init_do() {
  filename=$(basename $2)
  ##Copied this. Could be done better.
  vers=$(awk -F_ '{print $1}' <<<"$filename")
  # Files greater then equal to 50 do not need sudo
  if [[ "$is_standard_user" = false || $vers -ge 50 ]]; then
    source "$2"
  else
      # For Init files we only run os specific files.
      if [[ $filename == *$OS* ]]; then
        sudo -H -E TMPDIR=/tmp bash -m -c "source $DOTFILES_HOME/bin/dotfiles source; source $2"
    else
        sudo -H -E TMPDIR=/tmp bash -m -c "source $2"
    fi
 fi 
}

# Copy files.
function copy_header() { e_header "Copying files into home directory"; }
function copy_test() {
  if [[ -e "$2" && ! "$(cmp "$1" "$2" 2> /dev/null)" ]]; then
    echo "same file"
  elif [[ "$1" -ot "$2" ]]; then
    echo "destination file newer"
  fi
}
function copy_do() {
  e_success "Copying ~/$1."
  cp "$2" ~/
}

# Link files.
function link_header() { e_header "Linking files into home directory"; }
function link_test() {
  [[ "$1" -ef "$2" ]] && echo "same file"
}
function link_do() {
  e_success "Linking ~/$1. ${2#$HOME/}"
  ln -sf ${2#$HOME/} ~/
}

# Copy, link, init, etc.
function do_stuff() {
  local base dest skip
  local files=(~/.dotfiles/$1/*)
  # No files? abort.
  if (( ${#files[@]} == 0 )); then return; fi
  # Run _header function only if declared.
  [[ $(declare -f "$1_header") ]] && "$1_header"
  # Iterate over files.
  for file in "${files[@]}"; do
    base="$(basename $file)"
    dest="$HOME/$base"
    # Run _test function only if declared.
    if [[ $(declare -f "$1_test") ]]; then
      # If _test function returns a string, skip file and print that message.
      skip="$("$1_test" "$file" "$dest")"
      if [[ "$skip" ]]; then
        e_error "Skipping ~/$base, $skip."
        continue
      fi
      # Destination file already exists in ~/. Back it up!
      if [[ -e "$dest" ]]; then
        e_arrow "Backing up ~/$base."
        # Set backup flag, so a nice message can be shown at the end.
        backup=1
        # Create backup dir if it doesn't already exist.
        [[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"
        # Backup file / link / whatever.
        mv "$dest" "$backup_dir"
      fi
    fi
    # Do stuff.
    "$1_do" "$base" "$file"
  done
}

# Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
function path_remove() {
  local arg path
  path=":$PATH:"
  for arg in "$@"; do path="${path//:$arg:/:}"; done
  path="${path%:}"
  path="${path#:}"
  echo "$path"
}


function setdiff() {
  if [[ "$1" == 1 ]]; then 
    shift; set 1 "diff" "$@"
  else
    set "diff" "$@"
  fi
  
}

function setcomp() {
  if [[ "$1" == 1 ]]; then 
    shift; set 1 "comp" "$@"
  else
    set "comp" "$@"
  fi
  
}

# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
# From http://stackoverflow.com/a/1617303/142339
function set() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$2" ]]; then
    local setdiffA setdiffB setdiffC
    setdiffA=($2); setdiffB=($3)
  fi
  setdiffC=()
  for a in "${setdiffA[@]}"; do
    skip=
    if [[ "$1" == "comp" ]]; then skip=1; fi
    for b in "${setdiffB[@]}"; do
      if [[ "$1" == "diff" ]]; then 
        [[ "$(echo $a | awk '{ print $1 }')" == "$(echo $b | awk '{ print $1 }')" ]] && skip=1 && break
      elif [[ "$1" == "comp" ]]; then 
        [[ "$(echo $a | awk '{ print $1 }')" == "$(echo $b | awk '{ print $1 }')" ]] && skip= && break
      fi
    done
    [[ "$skip" ]] || setdiffC=("${setdiffC[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiffA setdiffB setdiffC; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$2" ]] && echo "${setdiffC[@]}"
}

# For testing.
function assert() {
  local success modes equals actual expected
  modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
  actual="$("$@")"
  [[ "$actual" == "$expected" ]] && success=1 || success=0
  ${modes[success]} "\"$actual\" ${equals[success]} \"$expected\""
}

