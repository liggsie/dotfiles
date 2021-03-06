#!/bin/bash

# Current git branch or nothing.
function br {
  local ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

# Display a little time-of-day indicator as the first character of the PS1.
function _prompt_prefix {
  local hour=`date +%k`  # Get current hour in 24-hr format.
  if ((0<=$hour && $hour<=6))
  then
    local message="🌙"  # Crescent moon.
  elif ((7<=$hour && $hour<=11))
  then
    local message="☕"  # Coffee cup.
  elif ((12<=$hour && $hour<=13))
  then
    local message="🍴"  # Knife and fork.
  elif ((14<=$hour && $hour<=17))
  then
    local message="💡"  # Lightbulb.
  elif ((18<=$hour && $hour<=23))
  then
    local message="🍺"  # Beer mug.
  else
    local message="something wrong"  # Should never happen.
  fi
  echo "$message  "
}

# What to display as prompt suffix in Bash. Most sensibly represented as '$'.
function _prompt_suffix {
  echo '$ '
}

function _shortpath {
  #   How many characters of the $PWD should be kept
  local pwd_length=30
  local canonical=`pwd -P`
  local lpwd="${canonical/#$HOME/~}"
  if [ $(echo -n $lpwd | wc -c | tr -d " ") -gt $pwd_length ]
    then newPWD="...$(echo -n $lpwd | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
    else newPWD="$(echo -n $lpwd)"
  fi
  echo $newPWD
}

# Display current branch in PS1.
function _git_branch_ps1 {
  local branch_name=`br`
  if [ -n "$branch_name" ]; then
    echo "($branch_name)"
  else
    return  # Not a git repo.
  fi
}

# Taken from http://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# Also read this: http://superuser.com/questions/246625/bash-command-prompt-overwrites-the-current-line
# Use the start and stop tokens to define a period of time for color to be activated.
WHITE="0;37m\]"
YELLOW="0;33m\]"
GREEN="0;32m\]"
RED="0;31m\]"
START="\[\e["
STOP="\[\e[m\]"
PROMPT_COMMAND='RET=$?;'
RET_VALUE='$(echo $RET)'
# export PROMPT_COMMAND='PS1="\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\!] $START$YELLOW\u@\h:$STOP $START$WHITE\$(shortpath)$STOP$START$RED\$(parse_git_branch)$STOP $(prompt_suffix)"'
export PROMPT_COMMAND='PS1="$(_prompt_prefix)$START$WHITE\$(_shortpath)$STOP$START$RED\$(_git_branch_ps1)$STOP $START$YELLOW$(_prompt_suffix)$STOP"'

# How to set ls colors: http://www.napolitopia.com/2010/03/lscolors-in-osx-snow-leopard-for-dummies/
# This DOES NOT work in linux (at least not Fedora). In Linux, need to change /etc/DIR_COLORS.
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='GxHxxxxxBxxxxxxxxxgxgx'

# Enable the ability to prevent addition to .bash_history with prepended space.
export HISTCONTROL=ignorespace

# Put shell into vim mode (!).
set -o vi

# added by travis gem
# [ -f /Users/dliggat/.travis/travis.sh ] && source /Users/dliggat/.travis/travis.sh

