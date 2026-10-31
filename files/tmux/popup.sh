#!/bin/sh
# prefix s, a, t, g and K: a display-popup over its window dimmed, like the floating windows in nvim.
# popup.sh <window id> <client> <display-popup args...>; display-popup returns once the popup
# closes, then the dim goes, on the window it was put on even if the popup switched sessions.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

window=$1 client=$2
shift 2
tmux set -w -t "$window" window-style dim=40 \; set -w -t "$window" window-active-style dim=40
tmux display-popup -c "$client" "$@"
# the window may be gone by now (worktree.sh removes the session it is in), and run-shell would
# show the error over the pane
tmux set -wu -t "$window" window-style \; set -wu -t "$window" window-active-style 2>/dev/null
exit 0
