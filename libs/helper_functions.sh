#!/bin/bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m➜\033[0m  $@"; }

ret=""

function convert_list_to_array() {
  # Convert args to arrays, handling both space- and newline-separated lists.
  local desired
  read -ra  desired < <(echo "$1" | tr '\n' ' ')
  echo "${desired[@]}"
}

# Given a list of undesired items and installed items, return a list
# of installed items. Arrays in bash are insane (not in a good way).
function to_remove() {
  local debug desired installed i desired_s installed_s remain
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  # Convert args to arrays, handling both space- and newline-separated lists.
  read -ra desired < <(echo "$1" | tr '\n' ' ')
  read -ra installed < <(echo "$2" | tr '\n' ' ')
  # Sort desired and installed arrays.
  unset i; while read -r; do desired_s[i++]=$REPLY; done < <(
    printf "%s\n" "${desired[@]}" | sort
  )
  unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
    printf "%s\n" "${installed[@]}" | sort
  )
  
  # Get the difference. comm is awesome.
  unset i; while read -r; do remain[i++]=$REPLY; done < <(
    comm -12 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
  )
  [[ "$debug" ]] && for v in desired desired_s installed installed_s remain; do
    echo "$v ($(eval echo "\${#$v[*]}")) $(eval echo "\${$v[*]}")"
  done
  echo "${remain[@]}"
}

# Given a list of desired items and installed items, return a list
# of uninstalled items in the ret global variable.
# A. Items will preserve the you dictate in your array.
#    That way you can control what gets installed when.
# B. You can supply items with args by placing "software --args"
#    Inside your array. 
# Expects to get array as input by calling function like this:
# to_install arr1[@] arr2[@] .. and the
# to convert a space or newline seperated list to array call
# brew_list="$(convert_list_to_array "$(brew list)")"
function to_install() {
  local debug desired installed i installed_s remain
  local remain=()
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  
  declare -a desired=("${!1}")
  declare -a installed=("${!2}")
  
  # Sort the installed arrays.
  unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
    printf "%s\n" "${installed[@]}" | sort
  )
  
  # Iterate through the array desired array searching in the sorted array
  # Search time is log N * M times it happens.
  let installed_size=${#installed[@]}
  for element in "${desired[@]}"; do
    # Split up element just incase its a complex
    # I.E. git --universal
    element_s=( $element )
    # Due a log N search.
    let start=0
    let end=$installed_size-1
    element_found=false
    while [ $start -le $end ]
    do

        let tmp=$start+$end
        mid=$(printf "%.0f" $(echo "scale=2;$tmp/2" | bc))
        #echo "${installed_s[$mid]} ${element_s[0]}"
        if [ ${installed_s[$mid]} = ${element_s[0]} ]; then
            element_found=true
            break
        
        elif [ ${installed_s[$mid]} \< ${element_s[0]} ]; then
            let start=$mid+1
        
        elif [ ${installed_s[$mid]} \> ${element_s[0]} ]; then
            let end=$mid-1
        
        else
            # THIS SHOULD NEVER HAPPEN
            e_error "Element Not Found."
            element_found=false
            break
        fi
    done
    
    if [[ $element_found == false ]]; then
      # We insert back the original element to preserve flags i.e. --universal
      remain+=( "$element" )
    fi
  done

  [[ "$debug" ]] && for v in desired installed installed_s remain; do
    echo "$v ($(eval echo "\${#$v[*]}")) $(eval echo "\${$v[*]}")"
  done
  
  ret=( "${remain[@]}" )
  #echo "${remain[@]}"
}

# Offer the user a chance to skip something.
function skip() {
  REPLY=noskip
  read -t 5 -n 1 -s -p "To skip, press X within 5 seconds. "
  if [[ "$REPLY" =~ ^[Xx]$ ]]; then
    echo "Skipping!"
  else
    echo "Continuing..."
    return 1
  fi
}

# Offer the user a chance to skip something.
function no-skip() {
  REPLY=noskip
  read -t 5 -n 1 -s -p "To NOT skip, press X within 5 seconds. "
  if [[ "$REPLY" =~ ^[Xx]$ ]]; then
    echo "Continuing..."
    return 1
  else
    echo "Skipping.."
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
      if [[ $vers == 10 && $filename == *$OS* ]]; then
        sudo -E "source $2" 
    else
        sudo -E "source $2"
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

# Utilities, helpers. Moved into here just to make it cleaner
# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
  IFS=:
  # convert it to an array
  t=($PATH)
  unset IFS
  # perform any array operations to remove elements from the array
  t=(${t[@]%%$1})
  IFS=:
  # output the new array
  echo "${t[*]}"
}
