#!/bin/sh
# prefix a: fzf over the panes running claude code in every session, the ones waiting for you
# first, with a live preview of the selected pane; enter jumps there (session, window and pane).
# The state comes from claude's hooks (files/claude/settings.json): they run `agents.sh state ...`,
# which keeps it in the pane option @agent_state, so it goes away with the pane.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

if [ "$1" = state ]; then
  [ -n "$TMUX_PANE" ] || exit 0
  state=$2
  case $state in
    # PreToolUse: AskUserQuestion is a question to you, any other tool means it is working
    tool) if grep -q '"tool_name": *"AskUserQuestion"'; then state='wait'; else state=working; fi ;;
    end) tmux set -pu -t "$TMUX_PANE" @agent_state 2>/dev/null; exit 0 ;;
  esac
  tmux set -p -t "$TMUX_PANE" @agent_state "$state" 2>/dev/null
  exit 0
fi

if [ "$1" = list ]; then
  # a shell in the pane: claude has exited without SessionEnd (killed), its state is stale;
  # the title without the status glyph claude puts in front ("✳ ", "⠐ "), as in tmux.conf
  tmux list-panes -a -F "#{@agent_state}	#{pane_id}	#{session_name}:#{window_index}	#{pane_current_command}	#{s/^[^A-Za-z0-9А-Яа-яЁё]+ //:pane_title}" 2>/dev/null |
    awk -F '\t' '
      $1 == "" || $4 ~ /^-?(zsh|bash|sh)$/ { next }
      {
        if ($1 == "wait") { rank = 0; icon = "\033[38;2;219;182;113m▲" }
        else if ($1 == "working") { rank = 1; icon = "\033[38;2;81;168;179m󰔟" }
        else if ($1 == "done") { rank = 2; icon = "\033[38;2;143;181;115m✔" }
        else { rank = 3; icon = "\033[38;2;90;91;94m○" }
        # the title goes last: awk pads by bytes, a cyrillic one would break the columns
        printf "%d\t%s\t%s\033[0m %-16s %s\n", rank, $2, icon, $3, $5
      }' |
    sort -s -n -k1,1 | cut -f2-
  exit
fi

# a pane target makes switch-client select its window and pane as well
pane=$("$0" list | fzf \
  --ansi \
  --delimiter '\t' \
  --with-nth 2 \
  --prompt 'agent> ' \
  --header 'enter: jump · ctrl-r: refresh' \
  --preview 'tmux capture-pane -ep -t {1}' \
  --preview-window 'right,40%,border-left' \
  --bind "ctrl-r:reload($0 list)" | cut -f1)

[ -n "$pane" ] && tmux switch-client -t "$pane"
