#
# Defines tmux aliases and provides for auto launching it at start-up.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Colin Hebert <hebert.colin@gmail.com>
#   Georges Discry <georges@discry.be>
#   Xavier Cambar <xcambar@gmail.com>
#

# Return if requirements are not found.
if (( ! $+commands[tmux] )); then
  return 1
fi

#
# Auto Start
#

function prompt_for_tmux_start {

  echo "---  ***  ***  *** --- "
  echo "start tmux session?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes)
        echo "starting tmux"
        tmux start-server

        tmux_session="tmux-$$"
        tmux \
            new-session -d -s "$tmux_session" \; \
            set-option -t "$tmux_session" destroy-unattached off &> /dev/null
        exec tmux attach-session

      ;;
      No)
        echo "not starting tmux"
        break
      ;;
      *) break ;;
    esac
  done

}

function prompt_for_tmux_resume {

  echo "---  ***  ***  *** --- "
  echo "Existing tmux session found: resume last session?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes)
        exec tmux attach-session
      ;;
      No) return 1 && break ;;
      *) return 1 && break ;;
    esac
  done

}

if tmux has-session 2> /dev/null; then
    session="$(
        tmux list-sessions \
        | awk '{print $1}' \
        | head -1 \
        | cut -d: -f 1)"

else
    session=""
fi

if [[ -n "$session" ]]; then
  if [[ -z "$TMUX" ]] && zstyle -t ':prezto:module:tmux' prompt-resume; then
    prompt_for_tmux_resume || prompt_for_screen_start
  elif [[ -z "$TMUX" ]] && zstyle -t ':prezto:module:tmux' prompt-start; then
    prompt_for_tmux_start
  fi
else
  if [[ -z "$TERM" ]] || zstyle -t ':prezto:module:tmux' prompt-start; then
    prompt_for_tmux_start
  fi
fi

if [[ -z "$STY" ]] && zstyle -t ':prezto:module:tmux' auto-start; then
  if [[ -n "$session" ]] && zstyle -t ':prezto:module:tmux' resume; then
    exec tmux attach-session
  else
    tmux start-server
    tmux_session="tmux-$$"
    tmux \
        new-session -d -s "$tmux_session" \; \
        set-option -t "$tmux_session" destroy-unattached off &> /dev/null
  fi
fi

#
# Aliases
#

alias tmuxa="tmux $_tmux_iterm_integration new-session -A"
alias tmuxl='tmux list-sessions'
