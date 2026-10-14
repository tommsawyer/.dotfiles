## Dotfiles

macOS: zsh (oh-my-zsh), tmux, neovim, lazygit, delta — all in the tokyonight theme.

### Install

```sh
git clone <this repo> ~/.dotfiles
cd ~/.dotfiles
make install
```

`make install` installs everything from `files/Brewfile` (including the JetBrains
Mono Nerd Font), the emmet language server, oh-my-zsh and the russian spell
file, then symlinks the configs. Existing non-symlinked configs are moved to
`*.backup`.

After that:

- iTerm2: Settings → Profiles → Colors → Color Presets → import
  `files/iterm/tokyonight_night.itermcolors`, font JetBrainsMono Nerd Font Mono
- `nvim` installs its plugins on the first start

### Layout

| Path | Linked to |
|---|---|
| `files/zshrc` | `~/.zshrc` |
| `files/tmux.conf` | `~/.tmux.conf` |
| `files/nvim` | `~/.config/nvim` |
| `files/bat` | `~/.config/bat` |
| `files/lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` |
| `files/git/delta.gitconfig` | included from `~/.gitconfig` |
