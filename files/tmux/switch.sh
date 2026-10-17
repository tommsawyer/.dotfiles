#!/bin/sh
# prefix s: fzf over tmux sessions, with a live preview of the active pane of the selected one.
# enter: switch to it; ctrl-x: kill it; a name that matches nothing + enter: new session
# with that name. Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

if [ "$1" = list ]; then
  tmux list-sessions -F "#{session_name}	#{session_windows}	#{pane_current_path}" |
    awk -F '\t' -v home="$HOME" '{ sub("^" home, "~", $3); printf "%-20s %-10s %s\n", $1, $2 " win", $3 }'
  exit
fi

# =name: exact session name (a leading dot or a prefix of another name is not misread)
out=$("$0" list | fzf \
  --print-query \
  --prompt 'session> ' \
  --header 'enter: switch · ctrl-x: kill · new name + enter: new session' \
  --preview 'tmux capture-pane -ep -t ={1}:' \
  --preview-window 'right,55%,border-left' \
  --bind "ctrl-x:execute-silent(tmux kill-session -t ={1})+reload($0 list)")

query=$(printf '%s\n' "$out" | sed -n 1p)
target=$(printf '%s\n' "$out" | sed -n 2p | awk '{ print $1 }')

if [ -n "$target" ]; then
  tmux switch-client -t "=$target"
elif [ -n "$query" ]; then
  tmux has-session -t "=$query" 2>/dev/null || tmux new-session -d -s "$query" -c "$HOME"
  tmux switch-client -t "=$query"
fi
