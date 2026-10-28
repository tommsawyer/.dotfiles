# geninclude from kitty.conf: the colours of the current theme, what `theme light|dark` wrote
# to ~/.local/state/theme, dark without it (as theme/env.sh reads it)
import os

state = os.path.join(os.environ.get("XDG_STATE_HOME") or os.path.expanduser("~/.local/state"), "theme")
try:
    with open(state) as f:
        light = f.read().strip() == "light"
except OSError:
    light = False
print("include onedark-light.conf" if light else "include onedark-warmer.conf")
