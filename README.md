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

- iTerm2: Settings → Profiles → select "Tokyo Night" → Other Actions → Set as
  Default (the profile itself — colors, font, no mark indicators — comes from
  `files/iterm/tokyonight.json` as a dynamic profile)
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
| `files/iterm/tokyonight.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/tokyonight.json` |
