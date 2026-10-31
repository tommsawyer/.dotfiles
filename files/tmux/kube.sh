#!/bin/sh
# status-right: the current kubectl context ("󱃾 prod"); nothing without one. Of a KUBECONFIG list
# only the first file is read.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

config=${KUBECONFIG:-$HOME/.kube/config}
awk '/^current-context:/ { gsub(/"/, "", $2); if ($2 != "") print "󱃾 " $2; exit }' "${config%%:*}" 2>/dev/null
