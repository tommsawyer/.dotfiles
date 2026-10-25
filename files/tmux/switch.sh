#!/bin/sh
# prefix s and ctrl-g in zsh: fzf over tmux sessions, with a live preview of the selected
# session's active pane (a directory gets its session with `tm`).
# enter: open it (connect.sh: switch inside tmux, attach outside); ctrl-x: kill a session;
# a name that matches nothing + enter: new session with that name.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

dir=$(dirname "$0")

if [ "$1" = list ]; then
  tmux list-sessions -F "#{session_name}	#{session_windows}	#{pane_current_path}" 2>/dev/null |
    awk -F '\t' -v home="$HOME" '{ sub("^" home, "~", $3); printf "%-20s %-10s %s\n", $1, $2 " win", $3 }'
  exit
fi

# "=name:" is an exact session name; without the colon tmux reads a dot as window.pane (.dotfiles);
# '=' quoted: fzf runs these in $SHELL, and zsh expands an unquoted =word to the path of a command
out=$("$0" list | fzf \
  --print-query \
  --prompt 'session> ' \
  --header 'enter: open · ctrl-x: kill · new name + enter: new session' \
  --preview "tmux capture-pane -ep -t '='{1}':'" \
  --preview-window 'right,55%,border-left' \
  --bind "ctrl-x:execute-silent(tmux kill-session -t '='{1}':')+reload($0 list)")

query=$(printf '%s\n' "$out" | sed -n 1p)
target=$(printf '%s\n' "$out" | sed -n 2p | awk '{ print $1 }')

if [ -n "$target" ]; then
  exec "$dir/connect.sh" "$target"
elif [ -n "$query" ]; then
  tmux has-session -t "=$query:" 2>/dev/null || tmux new-session -d -s "$query" -c "$HOME"
  exec "$dir/connect.sh" "$query"
fi
