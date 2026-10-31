#!/bin/sh
# prefix a: fzf over the panes running claude code in every session, the ones waiting for you
# first, with a live preview of the selected pane; enter jumps there (session, window and pane).
# prefix A (`agents.sh next <pane> <client>`): straight to the agent that needs you, without fzf.
# The state comes from claude's hooks (files/claude/settings.json): they run `agents.sh state ...`,
# which keeps it in the pane option @agent_state, so it goes away with the pane. "done" turns
# "seen" once you come to the pane (the pane-focus-in hook in tmux.conf), or at once when it
# finishes in front of you: the pane is the one shown on a focused client.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

if [ "$1" = state ]; then
  [ -n "$TMUX_PANE" ] || exit 0
  state=$2
  case $state in
    # PreToolUse: AskUserQuestion is a question to you, any other tool means it is working
    tool) if grep -q '"tool_name": *"AskUserQuestion"'; then state='wait'; else state=working; fi ;;
    end) tmux set -pu -t "$TMUX_PANE" @agent_state 2>/dev/null; exit 0 ;;
    done)
      session=$(tmux display -p -t "$TMUX_PANE" '#{?#{&&:#{pane_active},#{window_active}},#{session_id},}' 2>/dev/null)
      [ -n "$session" ] && tmux list-clients -t "$session" -F '#{client_flags}' 2>/dev/null |
        grep -q focused && state=seen ;;
  esac
  tmux set -p -t "$TMUX_PANE" @agent_state "$state" 2>/dev/null
  exit 0
fi

# the icons and fzf's colours in the palette of the current theme
# shellcheck source=files/theme/env.sh
. ~/.config/theme/env.sh

if [ "$1" = list ]; then
  # a shell in the pane: claude has exited without SessionEnd (killed), its state is stale;
  # the title without the status glyph claude puts in front ("✳ ", "⠐ "), as in tmux.conf
  tmux list-panes -a -F "#{@agent_state}	#{pane_id}	#{session_name}:#{window_index}	#{pane_current_command}	#{s/^[^A-Za-z0-9А-Яа-яЁё]+ //:pane_title}" 2>/dev/null |
    awk -F '\t' -v wait="$(thm_ansi "$thm_yellow")" -v working="$(thm_ansi "$thm_cyan")" \
      -v done="$(thm_ansi "$thm_green")" -v other="$(thm_ansi "$thm_grey")" '
      $1 == "" || $4 ~ /^-?(zsh|bash|sh)$/ { next }
      {
        if ($1 == "wait") { rank = 0; icon = wait "󰂞" }
        else if ($1 == "done") { rank = 1; icon = done "󰗠" }
        else if ($1 == "working") { rank = 2; icon = working "󰔟" }
        else if ($1 == "seen") { rank = 3; icon = other "󰄬" }
        else { rank = 3; icon = other "○" }
        # the title goes last: awk pads by bytes, a cyrillic one would break the columns;
        # session:window once more, hidden, for the preview label
        printf "%d\t%s\t%s\033[0m %-16s %s\t%s\n", rank, $2, icon, $3, $5, $3
      }' |
    sort -s -n -k1,1 | cut -f2-
  exit
fi

# the first waiting agent, else the first finished one you have not seen; the pane you are in skipped
if [ "$1" = next ]; then
  pane=$(tmux list-panes -a -F "#{@agent_state}	#{pane_id}	#{pane_current_command}" 2>/dev/null |
    awk -F '\t' -v here="$2" '$2 == here || $3 ~ /^-?(zsh|bash|sh)$/ { next }
      $1 == "wait" { print $2; found = 1; exit }
      $1 == "done" && !d { d = $2 }
      END { if (!found && d) print d }')
  if [ -n "$pane" ]; then tmux switch-client -c "$3" -t "$pane"
  else tmux display-message -c "$3" "no agent needs you"; fi
  exit
fi

# a pane target makes switch-client select its window and pane as well
pane=$("$0" list | fzf \
  --ansi \
  --delimiter '\t' \
  --with-nth 2 \
  --prompt 'agent> ' \
  --footer 'enter: jump · ctrl-r: refresh' \
  --preview 'tmux capture-pane -ep -t {1}' \
  --preview-window 'right,55%,border-left' \
  --bind 'focus:transform-preview-label:printf " %s " {3}' \
  --bind "ctrl-r:reload($0 list)" | cut -f1)

[ -n "$pane" ] && tmux switch-client -t "$pane"
