#!/bin/sh
# lazygit's custom commands (files/lazygit/config.yml): a git worktree in ~/.worktrees/<repo>/<name>
# with a tmux session of its own, <repo>/<name> (connect.sh names it). A slash of the branch turns
# into "-" in both. Errors go to lazygit, which shows them.
# worktree.sh new <branch>: a new worktree, from HEAD or of an existing branch, and its session
# worktree.sh open <path>: the session of a worktree, created if missing
# worktree.sh rm <path>: the worktree and its session, the branch too once it is merged; a worktree
# with changes stays, git refuses without --force.
# POPUP_CLIENT comes from prefix g: lazygit runs in a popup there, and a popup stays on its client
# through a session switch, so it is closed by hand, last: that ends this script too.
# Lives in ~/.config/tmux (the whole folder is linked by `make symlinks`).

dir=$(dirname "$0")
base=$HOME/.worktrees

close_popup() {
  if [ -n "$POPUP_CLIENT" ]; then tmux display-popup -C -c "$POPUP_CLIENT"; fi
}

open() {
  "$dir/connect.sh" "$1" || exit
  close_popup
}

# the main worktree, also when called from a linked one
root=$(git rev-parse --path-format=absolute --git-common-dir) || exit
root=$(dirname "$root")

case $1 in
  new)
    branch=$2
    path=$base/$(basename "$root")/$(printf %s "$branch" | tr / -)
    if git show-ref -q --verify "refs/heads/$branch" || git show-ref -q --verify "refs/remotes/origin/$branch"; then
      git worktree add "$path" "$branch"
    else
      git worktree add -b "$branch" "$path"
    fi || exit
    open "$path"
    ;;
  open)
    open "$2"
    ;;
  rm)
    path=$2
    [ "$path" != "$root" ] || { echo "the main worktree stays" >&2; exit 1; }
    branch=$(git -C "$path" symbolic-ref -q --short HEAD)
    # from the main one: lazygit may be running in the folder that goes away
    cd "$root" || exit
    git worktree remove "$path" || exit
    if [ -n "$branch" ]; then git branch -d "$branch" 2>/dev/null || echo "$branch is not merged, kept"; fi

    # sessions of worktrees made elsewhere are not ours to kill
    case $path in "$base/"*) ;; *) exit 0 ;; esac
    session=${path#"$base/"}
    tmux has-session -t "=$session:" 2>/dev/null || exit 0
    current=$(tmux display -p ${POPUP_CLIENT:+-c "$POPUP_CLIENT"} '#{client_session}')
    if [ "$session" = "$current" ]; then
      "$dir/connect.sh" "$root"
      tmux kill-session -t "=$session:"
      close_popup
    else
      tmux kill-session -t "=$session:"
    fi
    ;;
  *)
    echo "usage: worktree.sh new <branch> | open <path> | rm <path>" >&2
    exit 1
    ;;
esac
