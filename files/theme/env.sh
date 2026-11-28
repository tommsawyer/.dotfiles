# shellcheck shell=sh disable=SC2034 # thm_* are for the scripts that source this
# The current theme, gruvbox-material (hard) dark or light: what `theme light|dark` wrote to
# ~/.local/state/theme, dark without it. Sets its palette (thm_*, for the zsh prompt and the
# fzf pickers) and exports what makes bat, delta, lazygit, fzf, tock and eza follow it.
# Sourced by zshrc (again at a prompt after a switch), the tmux pickers and `theme`, which also
# copies the exports into the tmux environment for its popups.
# Lives in ~/.config/theme (the whole folder is linked by `make symlinks`).

THEME=$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/theme" 2>/dev/null || :)
[ "$THEME" = light ] || THEME=dark

# thm_scheme: the current one's name, the stem of the bat theme, the delta feature, the kitty
# colours (files/kitty) and the zsh-patina theme. thm_cyan is the theme's aqua, its cyan in
# the terminal
if [ "$THEME" = light ]; then
  thm_bg0="#F9F5D7" thm_bg3="#F2E5BC" thm_fg="#654735"
  thm_grey="#A89984" thm_light_grey="#928374"
  thm_blue="#45707A" thm_cyan="#4C7A5D" thm_yellow="#B47109" thm_purple="#945E80"
  thm_green="#6C782E" thm_orange="#C35E0A" thm_red="#C14A4A"
  thm_scheme=gruvbox-material-light thm_bookokrat="Gruvbox Material Light"
  thm_tock_text="#4F3829" thm_tock_blue="#6A929A" thm_tock_red="#C87369"
  export LG_CONFIG_FILE="$HOME/Library/Application Support/lazygit/config.yml,$HOME/Library/Application Support/lazygit/light.yml"
else
  thm_bg0="#1D2021" thm_bg3="#3C3836" thm_fg="#D4BE98"
  thm_grey="#7C6F64" thm_light_grey="#928374"
  thm_blue="#7DAEA3" thm_cyan="#89B482" thm_yellow="#D8A657" thm_purple="#D3869B"
  thm_green="#A9B665" thm_orange="#E78A4E" thm_red="#EA6962"
  thm_scheme=gruvbox-material-dark thm_bookokrat="Gruvbox Material Dark"
  thm_tock_text=$thm_fg thm_tock_blue="#35756D" thm_tock_red="#B5453F"
  unset LG_CONFIG_FILE
fi
# tock draws today / the selected day in its text colour on red / blue: fg on the palette's
# accents is 1.4 - 1.7:1, so accents of its own, deeper in dark and softer in light, and a text
# colour with ~3:1 both on them and on the background (above)

# bat: its --theme-light / --theme-dark (bat/config); delta: a feature of delta.gitconfig
export THEME BAT_THEME="$THEME" DELTA_FEATURES="$thm_scheme"
# ${thm_fg}:regular in braces: zsh reads $thm_fg:r as the :r modifier
export FZF_DEFAULT_OPTS="--layout=reverse --info=inline-right --highlight-line \
  --color=fg:$thm_fg,bg:$thm_bg0,hl:$thm_blue,fg+:$thm_fg,bg+:$thm_bg3,hl+:$thm_cyan \
  --color=info:$thm_yellow,prompt:$thm_purple,pointer:$thm_orange,marker:$thm_green,spinner:$thm_purple \
  --color=header:$thm_cyan,border:$thm_grey,gutter:$thm_bg0,separator:$thm_grey,footer:$thm_light_grey \
  --color=scrollbar:$thm_grey,query:${thm_fg}:regular"

# tock (its own names for the roles: highlight is durations, secondary is today in the calendar);
# the tag colour has no env var, `theme` writes it to tock.yaml
export TOCK_THEME_NAME=custom TOCK_COLOR_PRIMARY="$thm_tock_blue" TOCK_COLOR_SECONDARY="$thm_tock_red" \
  TOCK_COLOR_TEXT="$thm_tock_text" TOCK_COLOR_SUBTEXT="$thm_light_grey" TOCK_COLOR_FAINT="$thm_grey" \
  TOCK_COLOR_HIGHLIGHT="$thm_yellow"

# thm_sgr "#7DAEA3" -> 38;2;125;174;163: the SGR codes of the palette colours given, several
# space-separated and nothing after the last (thm_ansi puts it straight into \033[...m, a space
# before the m makes it an unknown sequence); builtins only, it runs at every shell start.
# thm_ansi: the escape for text in the colour
thm_sgr() {
  sep=
  for c in "$@"; do
    c=${c#\#}
    printf '%s38;2;%d;%d;%d' "$sep" "0x${c%????}" "$(( (0x$c & 0xff00) >> 8 ))" "0x${c#????}"
    sep=' '
  done
}
thm_ansi() { printf '\033[%sm' "$(thm_sgr "$1")"; }

# eza (ls): EZA_COLORS takes SGR codes, not colours. Names in the palette: folders bold blue,
# symlinks and music cyan, executables and documents green, broken links, archives and sockets
# red, pipes and devices yellow, code, build and key files yellow, images and video purple, temp
# and compiled files grey. The columns muted (thm_light_grey), but the group/world-writable and
# setuid/setgid bits in red; punctuation (the -> of a link, dashes) in thm_grey. What is left
# out keeps eza's defaults, the terminal's 16 colours (kitty's are this palette). eza_colors(5)
# The colours in braces: zsh reads $blue:ln as the :l modifier
read -r blue cyan yellow purple green red grey muted <<EOF
$(thm_sgr "$thm_blue" "$thm_cyan" "$thm_yellow" "$thm_purple" "$thm_green" "$thm_red" "$thm_grey" "$thm_light_grey")
EOF
export EZA_COLORS="di=1;${blue}:ln=${cyan}:ex=${green}:or=${red}:pi=${yellow}:so=${red}:bd=${yellow}:\
cd=${yellow}:im=${purple}:vi=${purple}:mu=${cyan}:lo=${cyan}:co=${red}:do=${green}:cr=${yellow}:\
bu=${yellow}:sc=${yellow}:tm=${grey}:cm=${grey}:\
ur=${muted}:uw=${muted}:ux=${muted}:ue=${muted}:gr=${muted}:gx=${muted}:tr=${muted}:tx=${muted}:\
gw=${red}:tw=${red}:su=${red}:sf=${red}:xa=${grey}:\
sn=${muted}:sb=${muted}:uu=${muted}:uR=${muted}:un=${muted}:gu=${muted}:gR=${muted}:gn=${muted}:\
lc=${muted}:lm=${muted}:da=${muted}:in=${muted}:bl=${muted}:oc=${muted}:xx=${grey}"
