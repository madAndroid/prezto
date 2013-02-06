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

if [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' prompt-start; then
  echo "Do you wish to start a screen session?"
  sleep 1
  select yn in "Yes" "No"; do
    case $yn in 
      Yes) exec screen -S ZSH ;;
      No) break ;;
      *) break ;;
    esac
  done
fi
	
if [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' prompt-resume; then
  echo "Do you wish to resume last screen session?"
  sleep 1
  select yn in "Yes" "No"; do
    case $yn in 
      Yes) 
        session="$(
          screen -list 2> /dev/null \
            | sed '1d;$d' \
            | awk '{print $1}' \
            | head -1)"
        exec screen -x "$session"
      ;;
      No) break ;;
      *) break ;;
    esac
  done
fi

if [[ -z "$STY" ]] && zstyle -t ':prezto:module:screen' auto-start; then

  if [[ -n "$session" ]] && zstyle -t ':prezto:module:screen' resume; then
    session="$(
      screen -list 2> /dev/null \
        | sed '1d;$d' \
        | awk '{print $1}' \
        | head -1)"
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

