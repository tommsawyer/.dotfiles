#!/bin/sh
# Opens a tmux session for $1: an open session's name, a directory (~ allowed), or a word
# zoxide resolves to its best matching directory. A directory gets a session named after
# its folder (created there if missing). Switches inside tmux, where attaching would nest;
# attaches outside. Used by `tm` in zshrc and by switch.sh. Not `sesh connect`: it renames
# .dotfiles to _dotfiles, and names here have to match the sessions already open.

target=$1
case $target in "~"*) target=$HOME${target#"~"} ;; esac

# "=name:" is an exact session name; without the colon tmux reads a dot as window.pane (.dotfiles)
if tmux has-session -t "=$target:" 2>/dev/null; then
  name=$target
else
  if [ -d "$target" ]; then
    dir=$(cd "$target" && pwd)
  else
    dir=$(zoxide query -- "$target" 2>/dev/null) || { echo "tm: no session or directory matches '$1'" >&2; exit 1; }
  fi
  name=$(basename "$dir")
  tmux has-session -t "=$name:" 2>/dev/null || tmux new-session -d -s "$name" -c "$dir"
fi

if [ -n "$TMUX" ]; then
  tmux switch-client -t "=$name:"
else
  tmux attach-session -t "=$name:"
fi
