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
if [ ! -n "${BULLETTRAIN_PROMPT_CHAR+1}" ]; then
  BULLETTRAIN_PROMPT_CHAR="\$"
fi
if [ ! -n "${BULLETTRAIN_PROMPT_ROOT+1}" ]; then
  BULLETTRAIN_PROMPT_ROOT=true
fi

# STATUS
if [ ! -n "${BULLETTRAIN_STATUS_SHOW+1}" ]; then
  BULLETTRAIN_STATUS_SHOW=true
fi
if [ ! -n "${BULLETTRAIN_STATUS_EXIT_SHOW+1}" ]; then
  BULLETTRAIN_STATUS_EXIT_SHOW=false
fi
if [ ! -n "${BULLETTRAIN_STATUS_BG+1}" ]; then
  BULLETTRAIN_STATUS_BG=green
fi
if [ ! -n "${BULLETTRAIN_STATUS_ERROR_BG+1}" ]; then
  BULLETTRAIN_STATUS_ERROR_BG=red
fi
if [ ! -n "${BULLETTRAIN_STATUS_FG+1}" ]; then
  BULLETTRAIN_STATUS_FG=white
fi

# TIME
if [ ! -n "${BULLETTRAIN_TIME_SHOW+1}" ]; then
  BULLETTRAIN_TIME_SHOW=true
fi
if [ ! -n "${BULLETTRAIN_TIME_BG+1}" ]; then
  BULLETTRAIN_TIME_BG=white
fi
if [ ! -n "${BULLETTRAIN_TIME_FG+1}" ]; then
  BULLETTRAIN_TIME_FG=black
fi

# VIRTUALENV
if [ ! -n "${BULLETTRAIN_VIRTUALENV_SHOW+1}" ]; then
  BULLETTRAIN_VIRTUALENV_SHOW=true
fi
if [ ! -n "${BULLETTRAIN_VIRTUALENV_BG+1}" ]; then
  BULLETTRAIN_VIRTUALENV_BG=yellow
fi
if [ ! -n "${BULLETTRAIN_VIRTUALENV_FG+1}" ]; then
  BULLETTRAIN_VIRTUALENV_FG=white
fi
if [ ! -n "${BULLETTRAIN_VIRTUALENV_PREFIX+1}" ]; then
  BULLETTRAIN_VIRTUALENV_PREFIX=🐍
fi


# DIR
if [ ! -n "${BULLETTRAIN_DIR_SHOW+1}" ]; then
  BULLETTRAIN_DIR_SHOW=true
fi
if [ ! -n "${BULLETTRAIN_DIR_BG+1}" ]; then
  BULLETTRAIN_DIR_BG=blue
fi
if [ ! -n "${BULLETTRAIN_DIR_FG+1}" ]; then
  BULLETTRAIN_DIR_FG=white
fi
if [ ! -n "${BULLETTRAIN_DIR_CONTEXT_SHOW+1}" ]; then
  BULLETTRAIN_DIR_CONTEXT_SHOW=false
fi
if [ ! -n "${BULLETTRAIN_DIR_EXTENDED+1}" ]; then
  BULLETTRAIN_DIR_EXTENDED=true
fi

# GIT
if [ ! -n "${BULLETTRAIN_GIT_SHOW+1}" ]; then
  BULLETTRAIN_GIT_SHOW=true
fi
if [ ! -n "${BULLETTRAIN_GIT_BG+1}" ]; then
  BULLETTRAIN_GIT_BG=white
fi
if [ ! -n "${BULLETTRAIN_GIT_FG+1}" ]; then
  BULLETTRAIN_GIT_FG=black
fi
if [ ! -n "${BULLETTRAIN_GIT_EXTENDED+1}" ]; then
  BULLETTRAIN_GIT_EXTENDED=true
fi

# CONTEXT
if [ ! -n "${BULLETTRAIN_CONTEXT_SHOW+1}" ]; then
  BULLETTRAIN_CONTEXT_SHOW=false
fi
if [ ! -n "${BULLETTRAIN_CONTEXT_BG+1}" ]; then
  BULLETTRAIN_CONTEXT_BG=black
fi
if [ ! -n "${BULLETTRAIN_CONTEXT_FG+1}" ]; then
  BULLETTRAIN_CONTEXT_FG=default
fi

# GIT PROMPT
if [ ! -n "${BULLETTRAIN_GIT_PREFIX+1}" ]; then
  ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
else
  ZSH_THEME_GIT_PROMPT_PREFIX=$BULLETTRAIN_GIT_PREFIX
fi
if [ ! -n "${BULLETTRAIN_GIT_SUFFIX+1}" ]; then
  ZSH_THEME_GIT_PROMPT_SUFFIX=""
else
  ZSH_THEME_GIT_PROMPT_SUFFIX=$BULLETTRAIN_GIT_SUFFIX
fi
if [ ! -n "${BULLETTRAIN_GIT_DIRTY+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DIRTY=" ✘"
else
  ZSH_THEME_GIT_PROMPT_DIRTY=$BULLETTRAIN_GIT_DIRTY
fi
if [ ! -n "${BULLETTRAIN_GIT_CLEAN+1}" ]; then
  ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
else
  ZSH_THEME_GIT_PROMPT_CLEAN=$BULLETTRAIN_GIT_CLEAN
fi
if [ ! -n "${BULLETTRAIN_GIT_ADDED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"
else
  ZSH_THEME_GIT_PROMPT_ADDED=$BULLETTRAIN_GIT_ADDED
fi
if [ ! -n "${BULLETTRAIN_GIT_UNTRACKED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{yellow}✭%F{black}"
else
  ZSH_THEME_GIT_PROMPT_UNTRACKED=$BULLETTRAIN_GIT_UNTRACKED
fi

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
  [[ "$user" != "$BULLETTRAIN_CONTEXT_DEFAULT_USER" || -n "$BULLETTRAIN_IS_SSH_CLIENT" ]] && echo -n "${user}@%m"
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
    prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG

    if [[ $BULLETTRAIN_GIT_EXTENDED == true ]] then
      echo -n $(git_prompt_info)$(git_prompt_status)
    else
      echo -n $(git_prompt_info)
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
    prompt_segment $BULLETTRAIN_VIRTUALENV_BG $BULLETTRAIN_VIRTUALENV_FG $BULLETTRAIN_VIRTUALENV_PREFIX"  $(basename $virtualenv_path)"
  fi
}

prompt_time() {
  if [[ $BULLETTRAIN_TIME_SHOW == false ]] then
    return
  fi

  prompt_segment $BULLETTRAIN_TIME_BG $BULLETTRAIN_TIME_FG %D{%H:%M:%S}
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  if [[ $BULLETTRAIN_STATUS_SHOW == false ]] then
    return
  fi

  local symbols
  symbols=()
  [[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
  [[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"
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

  if [[ ${#BULLETTRAIN_PROMPT_CHAR} -eq 1 ]] then
    bt_prompt_char="${BULLETTRAIN_PROMPT_CHAR}"
  fi

  if [[ $BULLETTRAIN_PROMPT_ROOT == true ]] then
    bt_prompt_char="%(!.%F{red}#.%F{green}${bt_prompt_char}%f)"
  fi

  echo -n $bt_prompt_char
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?
  prompt_time
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='
%{%f%b%k%}$(build_prompt)
%{${fg_bold[default]}%}$(prompt_char) %{$reset_color%}'
