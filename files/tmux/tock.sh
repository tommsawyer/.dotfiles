#!/bin/sh
# status-right: the running tock activity, its description and how long it runs ("󰔛 Ревью 1h05m",
# "󰔛 Ревью 5m"); nothing when none runs. The description is cut to 30 characters (the template's
# printf counts characters, awk would count bytes). The log file comes from `make tock`.
# prefix t (`tock.sh pick`): fzf over the recent activities, the running one first; enter starts the
# selected one again (tock start stops the running one itself), ctrl-s stops; a new description +
# enter (alt-enter when it matches an old one) asks for its project in a second fzf, the recent
# projects first, a new name + enter makes a new one. A preview of today's report.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

if [ "$1" != pick ] && [ "$1" != list ]; then
  tock current --format '{{printf "%.30s" .Description}}	{{.DurationHMS}}' 2>/dev/null |
    awk -F '\t' 'NF == 2 {
        sub(/ +$/, "", $1)
        split($2, t, ":"); h = t[1] + 0; m = t[2] + 0
        printf " 󰔛 %s %s\n", $1, h ? sprintf("%dh%02dm", h, m) : m "m"
        exit
      }'
  exit
fi

# fzf's colours and the running activity in the palette of the current theme
# shellcheck source=files/theme/env.sh
. ~/.config/theme/env.sh

if [ "$1" = list ]; then
  # project and description go first on their own, hidden: what enter works with; jq pads the
  # project by characters (awk would by bytes, a cyrillic one would break the columns)
  { tock current --json 2>/dev/null || echo null; tock last --json -n 30 2>/dev/null || echo null; } |
    jq -rs --arg run "$(thm_ansi "$thm_yellow")" '
      def pad: . + ([range(18 - length)] | map(" ") | join(""));
      def hm: split(":") | map(tonumber) | if .[0] > 0 then "\(.[0])h\(.[1] | tostring | if length < 2 then "0" + . else . end)m" else "\(.[1])m" end;
      (.[0] // []) as $cur | (.[1] // []) as $last
      | ($cur[] | "run\t\(.project)\t\(.description)\t\($run)󰔛 \(.project | pad) \(.description)  \(.duration | hm)\u001b[0m"),
        ($last[] | select([.project, .description] as $k | $cur | map([.project, .description]) | index([$k]) | not)
          | "old\t\(.project)\t\(.description)\t  \(.project | pad) \(.description)")'
  exit
fi

# the query, the key (alt-enter or none) and the selected row
out=$("$0" list | fzf \
  --ansi \
  --print-query \
  --expect alt-enter \
  --delimiter '\t' \
  --with-nth 4 \
  --prompt 'task> ' \
  --footer 'enter: start · ctrl-s: stop · new task + enter (alt-enter): pick its project' \
  --preview 'tock report --today 2>/dev/null | tail -n +4' \
  --preview-window 'right,45%,border-left' \
  --preview-label ' today ' \
  --bind "ctrl-s:execute-silent(tock stop; tmux refresh-client -S)+reload($0 list)")
# esc: fzf still prints the query; 1 is enter on a query that matches nothing
[ $? -eq 130 ] && exit

query=$(printf '%s\n' "$out" | sed -n 1p)
key=$(printf '%s\n' "$out" | sed -n 2p)
row=$(printf '%s\n' "$out" | sed -n 3p)

if [ -n "$row" ] && [ "$key" != alt-enter ]; then
  [ "$(printf '%s' "$row" | cut -f1)" = run ] && exit
  project=$(printf '%s' "$row" | cut -f2)
  description=$(printf '%s' "$row" | cut -f3)
elif [ -n "$query" ]; then
  description=$query
  # the recent projects, each once; a name that matches nothing + enter: a new project
  out=$(tock last --json -n 200 2>/dev/null | jq -r '[.[].project] | reduce .[] as $p ([]; if index([$p]) then . else . + [$p] end) | .[]' |
    fzf --print-query --prompt 'project> ' --header "$description" \
      --footer 'enter: start · new name + enter: new project')
  [ $? -eq 130 ] && exit
  project=$(printf '%s\n' "$out" | sed -n 2p)
  [ -n "$project" ] || project=$(printf '%s\n' "$out" | sed -n 1p)
fi

if [ -n "$project" ] && [ -n "$description" ]; then
  tock start -p "$project" -d "$description" >/dev/null
  tmux refresh-client -S
fi
