#
# Defines GNU Screen aliases and provides for auto launching it at start-up.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Return if requirements are not found.
if (( ! $+commands[screen] )); then
  return 1
fi

#
# Auto Start
#

function prompt_for_screen_start {

  echo "---  ***  ***  *** --- "
  echo "start screen session?"
  select yn in "Yes" "No"; do
    case $yn in 
      Yes) 
        echo "starting screen"
        exec screen -S ZSH 
      ;;
      No) 
        echo "not starting screen"
        break 
      ;;
      *) break ;;
    esac
  done

}

function prompt_for_screen_resume {

  echo "---  ***  ***  *** --- "
  echo "Existing screen session found: resume last session?"
  select yn in "Yes" "No"; do
    case $yn in 
      Yes) 
        exec screen -x "$session"; return 0
      ;;
      No) return 1 && break ;;
      *) return 1 && break ;;
    esac
  done

}

session="$(
  screen -list 2> /dev/null \
  | sed '1d;$d' \
  | awk '{print $1}' \
  | head -1)"

if [[ -n "$session" ]]; then
  if [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' prompt-resume; then
    prompt_for_screen_resume || prompt_for_screen_start
  elif [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' prompt-start; then
    prompt_for_screen_start
  fi
else 
  if [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' prompt-start; then
    prompt_for_screen_start
  fi
fi

if [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' auto-start; then

  if [[ -n "$session" ]] && zstyle -t ':prezto:module:screen' resume; then
    exec screen -x "$session"
  else
#    exec screen -a -A -U -D -R -m "$SHELL" -l
    exec screen -S ZSH
  fi
fi


#
# Aliases
#

alias scr='screen'
alias scrl='screen -list'
alias scrn='screen -U -S'
alias scrr='screen -a -A -U -D -R'

