#!/bin/sh
# prefix s and ctrl-g in zsh: fzf over tmux sessions, the last attached first, so enter right away
# goes back to the previous one; the current one greyed out at the bottom (CURRENT_SESSION from the
# prefix s binding, the shell's own session for ctrl-g). A live preview of the selected session's
# active pane (a directory gets its session with `tm`).
# enter: open it (connect.sh: switch inside tmux, attach outside); ctrl-x: kill a session;
# a name that matches nothing + enter: new session with that name.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

dir=$(dirname "$0")

if [ "$1" = list ]; then
  [ -z "$CURRENT_SESSION" ] && [ -n "$TMUX_PANE" ] && CURRENT_SESSION=$(tmux display -p -t "$TMUX_PANE" '#S')
  # the name goes first again on its own, hidden: what the preview, kill and enter work with
  tmux list-sessions -F "#{session_last_attached}	#{session_name}	#{session_windows}	#{pane_current_path}" 2>/dev/null |
    sort -rn |
    awk -F '\t' -v home="$HOME" -v cur="$CURRENT_SESSION" '
      {
        sub("^" home, "~", $4)
        row = sprintf("%s\t%-20s %-10s %s", $2, $2, $3 " win", $4)
        if ($2 == cur) current = row; else print row
      }
      END { if (current != "") { sub("\t", "\t\033[38;2;90;91;94m", current); print current "  current\033[0m" } }'
  exit
fi

# "=name:" is an exact session name; without the colon tmux reads a dot as window.pane (.dotfiles);
# '=' quoted: fzf runs these in $SHELL, and zsh expands an unquoted =word to the path of a command
out=$("$0" list | fzf \
  --ansi \
  --print-query \
  --delimiter '\t' \
  --with-nth 2 \
  --prompt 'session> ' \
  --footer 'enter: open · ctrl-x: kill · new name + enter: new session' \
  --preview "tmux capture-pane -ep -t '='{1}':'" \
  --preview-window 'right,55%,border-left' \
  --bind 'focus:transform-preview-label:printf " %s " {1}' \
  --bind "ctrl-x:execute-silent(tmux kill-session -t '='{1}':')+reload($0 list)")

query=$(printf '%s\n' "$out" | sed -n 1p)
target=$(printf '%s\n' "$out" | sed -n 2p | cut -f1)

if [ -n "$target" ]; then
  exec "$dir/connect.sh" "$target"
elif [ -n "$query" ]; then
  tmux has-session -t "=$query:" 2>/dev/null || tmux new-session -d -s "$query" -c "$HOME"
  exec "$dir/connect.sh" "$query"
fi
