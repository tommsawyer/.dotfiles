# shellcheck shell=sh disable=SC2034 # thm_* are for the scripts that source this
# The current theme, onedark warmer (dark) or onedark light: what `theme light|dark` wrote to
# ~/.local/state/theme, dark without it. Sets its palette (thm_*, for the zsh prompt and the
# fzf pickers), its iTerm profile (thm_iterm, iterm/profile.json) and exports what makes bat,
# delta, lazygit, k9s and fzf follow it.
# Sourced by zshrc (again at a prompt after a switch), the tmux pickers and `theme`, which also
# copies the exports into the tmux environment for its popups.
# Lives in ~/.config/theme (the whole folder is linked by `make symlinks`).

THEME=$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/theme" 2>/dev/null || :)
[ "$THEME" = light ] || THEME=dark

if [ "$THEME" = light ]; then
  thm_bg0="#FAFAFA" thm_bg3="#DCDCDC" thm_fg="#383A42"
  thm_grey="#A0A1A7" thm_light_grey="#818387"
  thm_blue="#4078F2" thm_cyan="#0184BC" thm_yellow="#986801" thm_purple="#A626A4"
  thm_green="#50A14F" thm_orange="#C18401" thm_red="#E45649"
  thm_onedark=onedark-light thm_iterm="OneDark Light" thm_bookokrat="OneDark Light"
  export LG_CONFIG_FILE="$HOME/Library/Application Support/lazygit/config.yml,$HOME/Library/Application Support/lazygit/light.yml"
else
  thm_bg0="#232326" thm_bg3="#37383D" thm_fg="#A7AAB0"
  thm_grey="#5A5B5E" thm_light_grey="#818387"
  thm_blue="#57A5E5" thm_cyan="#51A8B3" thm_yellow="#DBB671" thm_purple="#BB70D2"
  thm_green="#8FB573" thm_orange="#C49060"
  # the warm style's red, a bit softer than warmer's #DE5D68
  thm_red="#E16D77"
  thm_onedark=onedark-warmer thm_iterm="OneDark Warmer" thm_bookokrat="OneDark Warmer"
  unset LG_CONFIG_FILE
fi

# bat: its --theme-light / --theme-dark (bat/config); delta: a feature of delta.gitconfig
export THEME BAT_THEME="$THEME" DELTA_FEATURES="$thm_onedark" K9S_SKIN="$thm_onedark"
# ${thm_fg}:regular in braces: zsh reads $thm_fg:r as the :r modifier
export FZF_DEFAULT_OPTS="--layout=reverse --info=inline-right --highlight-line \
  --color=fg:$thm_fg,bg:$thm_bg0,hl:$thm_blue,fg+:$thm_fg,bg+:$thm_bg3,hl+:$thm_cyan \
  --color=info:$thm_yellow,prompt:$thm_purple,pointer:$thm_orange,marker:$thm_green,spinner:$thm_purple \
  --color=header:$thm_cyan,border:$thm_grey,gutter:$thm_bg0,separator:$thm_grey \
  --color=scrollbar:$thm_grey,query:${thm_fg}:regular"

# the escape for text in a palette colour: thm_ansi "#57A5E5" -> \033[38;2;87;165;229m
thm_ansi() {
  set -- "${1#\#}"
  printf '\033[38;2;%d;%d;%dm' "0x$(echo "$1" | cut -c1-2)" "0x$(echo "$1" | cut -c3-4)" "0x$(echo "$1" | cut -c5-6)"
}
