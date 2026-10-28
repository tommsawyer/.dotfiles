#!/bin/sh
# status-right: branch of the active pane's directory plus lines added / removed since HEAD
# (staged and unstaged together, untracked files are not counted); nothing outside a repo.
# git.sh <dir> <added colour> <removed colour>, the colours from the tmux palette (theme-*.conf).
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

cd "$1" 2>/dev/null || exit
b=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit
# binary files have "-" for counts, awk takes them as 0
git diff HEAD --numstat 2>/dev/null |
  awk -v b="$b" -v add="$2" -v del="$3" '{ a += $1; d += $2 }
    END {
      printf " %s", b
      if (a) printf " #[fg=%s]+%d", add, a
      if (d) printf " #[fg=%s]-%d", del, d
      print ""
    }'
