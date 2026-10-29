#!/bin/sh
# status-right: the running tock activity, its description and how long it runs ("󰔛 Ревью 1h05m",
# "󰔛 Ревью 5m"); nothing when none runs. The description is cut to 30 characters (the template's
# printf counts characters, awk would count bytes). The log file comes from `make tock`.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

tock current --format '{{printf "%.30s" .Description}}	{{.DurationHMS}}' 2>/dev/null |
  awk -F '\t' 'NF == 2 {
      sub(/ +$/, "", $1)
      split($2, t, ":"); h = t[1] + 0; m = t[2] + 0
      printf " 󰔛 %s %s\n", $1, h ? sprintf("%dh%02dm", h, m) : m "m"
      exit
    }'
