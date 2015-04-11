# README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
#
# In addition, I recommend the
# [Tomorrow Night theme](https://github.com/chriskempson/tomorrow-theme) and, if
# you're using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over
# Terminal.app - it has significantly better color fidelity.

# ------------------------------------------------------------------------------
# CONFIGURATION
# The default configuration, that can be overwrite in your .zshrc file
# ------------------------------------------------------------------------------

VIRTUAL_ENV_DISABLE_PROMPT=true

# PROMPT
BULLETTRAIN_PROMPT_CHAR="\$"

# STATUS
#BULLETTRAIN_STATUS_EXIT_SHOW=false
BULLETTRAIN_STATUS_BG=green
BULLETTRAIN_STATUS_ERROR_BG=red
BULLETTRAIN_STATUS_FG=white

# BATTERY
BULLETTRAIN_BATTERY_SHOW=true
BULLETTRAIN_BATTERY_BG=default

# TIME
BULLETTRAIN_TIME_SHOW=true
BULLETTRAIN_TIME_BG=white
BULLETTRAIN_TIME_FG=black

# OS
BULLETTRAIN_OS_SHOW=true
BULLETTRAIN_OS_BG=black
BULLETTRAIN_OS_FG=white


# VIRTUALENV
BULLETTRAIN_VIRTUALENV_SHOW=true
BULLETTRAIN_VIRTUALENV_BG=yellow
BULLETTRAIN_VIRTUALENV_FG=white
BULLETTRAIN_VIRTUALENV_PREFIX=🐍


# DIR
BULLETTRAIN_DIR_SHOW=true
BULLETTRAIN_DIR_BG=blue
BULLETTRAIN_DIR_FG=white
BULLETTRAIN_DIR_CONTEXT_SHOW=false
BULLETTRAIN_DIR_EXTENDED=true

# GIT
BULLETTRAIN_GIT_SHOW=true
BULLETTRAIN_GIT_BG=245
BULLETTRAIN_GIT_FG=black
BULLETTRAIN_GIT_EXTENDED=true

# CONTEXT
BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_CONTEXT_BG=black
BULLETTRAIN_CONTEXT_FG=default

# GIT PROMPT
ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" ✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{yellow}✭%F{black}"

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------


# Context: user@hostname (who am I and where am I)
context() {
  local user="$(whoami)"
  [[ "$user" != "$BULLETTRAIN_CONTEXT_DEFAULT_USER" || -n "$SSH_CLIENT" ]] && echo -n "${user}@%m"
}
prompt_context() {
  [[ $BULLETTRAIN_CONTEXT_SHOW == false ]] && return

  local _context="$(context)"
  [[ -n "$_context" ]] && prompt_segment $BULLETTRAIN_CONTEXT_BG $BULLETTRAIN_CONTEXT_FG "$_context"
}

# Git
prompt_git() {
  if [[ $BULLETTRAIN_GIT_SHOW == false ]] then
    return
  fi

  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    #prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG

    if [[ $BULLETTRAIN_GIT_EXTENDED == true ]] then
      bt_git_prompt=$(git_prompt_info)$(git_prompt_status)
      prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG $bt_git_prompt
    else
      bt_git_prompt=$(git_prompt_info)
      prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG $bt_git_prompt
    fi
  fi
}



# Dir: current working directory
prompt_dir() {
  if [[ $BULLETTRAIN_DIR_SHOW == false ]] then
    return
  fi

  local dir=''
  local _context="$(context)"
  [[ $BULLETTRAIN_DIR_CONTEXT_SHOW == true && -n "$_context" ]] && dir="${dir}${_context}:"
  [[ $BULLETTRAIN_DIR_EXTENDED == true ]] && dir="${dir}%4(c:...:)%3c" || dir="${dir}%1~"
  prompt_segment $BULLETTRAIN_DIR_BG $BULLETTRAIN_DIR_FG $dir
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  if [[ $BULLETTRAIN_VIRTUALENV_SHOW == false ]] then
    return
  fi

  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    bt_virtualenv_path=$(basename $virtualenv_path)
    prompt_segment $BULLETTRAIN_VIRTUALENV_BG $BULLETTRAIN_VIRTUALENV_FG $BULLETTRAIN_VIRTUALENV_PREFIX"  $bt_virtualenv_path"
  fi
}

prompt_time() {
  if [[ $BULLETTRAIN_TIME_SHOW == false ]] then
    return
  fi
  prompt_segment $BULLETTRAIN_TIME_BG $BULLETTRAIN_TIME_FG %D{%H:%M:%S}
}

prompt_os() {
  if [[ $BULLETTRAIN_OS_SHOW == false ]] then
    return
  fi

  # OSX
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    BULLETTRAIN_OS_SYMBOL=''
  # Ubuntu.
  elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
    BULLETTRAIN_OS_SYMBOL='ⓤ'
  # Arch
  elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Arch ]]; then
    BULLETTRAIN_OS_SYMBOL='ⓐ'
  else
    return
  fi
  
  prompt_segment $BULLETTRAIN_OS_BG $BULLETTRAIN_OS_FG $BULLETTRAIN_OS_SYMBOL
}

prompt_battery() {
  if [[ $BULLETTRAIN_BATTERY_SHOW == false ]] then
    return
  fi
  
  bt_batt_pct=$(battery_pct_remaining)
  bt_display="$bt_batt_pct%%"
  if [[ "$bt_batt_pct" == "External Power" ]]; then
    BULLETTRAIN_BATTERY_FG=white
    bt_display="⚓"
  elif [[ "$bt_batt_pct" -gt "50" ]]; then
    BULLETTRAIN_BATTERY_FG=green
  elif [[ "$bt_batt_pct" -gt "20"  ]]; then
    BULLETTRAIN_BATTERY_FG=yellow
  else
    BULLETTRAIN_BATTERY_FG=red
  fi

  prompt_segment $BULLETTRAIN_BATTERY_BG $BULLETTRAIN_BATTERY_FG $bt_display
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="✘"
  #[[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
  #[[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="⚙"

  if [[ -n "$symbols" && $RETVAL -ne 0 ]] then
    prompt_segment $BULLETTRAIN_STATUS_ERROR_BG $BULLETTRAIN_STATUS_FG "$symbols"
  elif [[ -n "$symbols" ]] then
    prompt_segment $BULLETTRAIN_STATUS_BG $BULLETTRAIN_STATUS_FG "$symbols"
  fi

}

# Prompt Character
prompt_char() {
  local bt_prompt_char

  bt_prompt_char="${BULLETTRAIN_PROMPT_CHAR}"
  
  bt_prompt_char="%(!.%F{red}#.%F{green}${bt_prompt_char}%f)"
  
  echo -n $bt_prompt_char
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  prompt_os
  prompt_time
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}} 
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 2))
  echo "$(printf "%${LENGTH}s" " ")"
}


themills_precmd () {
  _1LEFT=$(build_prompt)
  _1RIGHT=" $(prompt_battery)"
  _1SPACES=`get_space $_1LEFT $_1RIGHT`
  print 
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

RPROMPT=''
PROMPT='%{${fg_bold[default]}%}$(prompt_char) %{$reset_color%}'


autoload -U add-zsh-hook
add-zsh-hook precmd themills_precmd