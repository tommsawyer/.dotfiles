<h1 align="center">dotfiles</h1>

<p align="center">
  macOS configs: kitty, zsh, tmux, neovim, lazygit and delta, all in one onedark
  theme — dark (warmer) or light, switched with the `theme` command.
</p>

<img src="assets/screenshot.png" alt="tmux and neovim: file tree, breadcrumbs, light and dark onedark themes split diagonally">

## Installation

Requires macOS and git (it comes with `xcode-select --install`); if Homebrew is
missing, `make install` installs it.

```sh
git clone https://github.com/tommsawyer/.dotfiles ~/.dotfiles
cd ~/.dotfiles
make install
```

Installs everything from [`files/Brewfile`](files/Brewfile) — the tools, the
language servers, the font — and symlinks the configs. nvim plugins are
downloaded on first launch.

## What's inside

### Editor: neovim

- **LSP and autocompletion** for Go (with templ templates), TypeScript, Python,
  Lua, Kotlin, Swift, Ruby, bash, HTML/CSS, YAML and JSON with schemas. The
  servers come from Brewfile, no Mason. Formatting runs on save.
- **Navigation:** file and text search, file tree, breadcrumbs with the
  function under the cursor, jumps by function/condition/loop, treesitter text
  objects.
- **Git in the file:** change highlights and line blame.
- **The Russian keyboard layout never gets in the way:** commands and flash
  labels work without switching, `:ц` acts as `:w`.

### Git

- The main tool is **lazygit**, in a tmux popup (`C-f g`).
- Diffs are drawn by **delta**: two columns on wide screens, onedark
  highlighting.

### Agentic development

- **Claude or opencode** open in a tmux pane next to nvim and survive its
  restart. From nvim you send them the spot under the cursor or the whole
  file; there are ready-made prompts: explain, review the file, finish the
  code here.
- **Agent menu:** `C-f a` — all agents across all sessions, `C-f A` — jump
  straight to the one waiting for you, or to the one that finished while you
  weren't looking.
- Agent statuses sit on the tabs, and a counter of agents waiting for you
  lives in the tmux status bar.

### Projects

- **One project — one tmux session.** `tm dotf` opens a session by name, path
  or zoxide history, `C-f s` switches; the previous session is at the top of
  the list, so `Enter` takes you back.
- **Worktrees with one keypress** (`Ctrl-N`): a copy of the repository on its
  own branch with its own session — leave an agent working there and come
  back to yours. Managed from the Worktrees tab in lazygit.

### Kubernetes

- The prompt lazily grows a ` k3d-dev/payments` segment — cluster and
  namespace: after the first kubectl-family command in the session, re-read
  only when the kubeconfig changes.
- `k` is kubectl with completions for subcommands, flags and pod names;
  `describe` and `get` are shown through bat with highlighting. stern,
  kubectx and k3d have completions too.

### Terminal

- **kitty** without a title bar, tabs or splits — tmux does those.
- zsh prompt: path relative to the repo root, exit code with the signal name,
  execution time, background jobs.
- zoxide and fzf for navigation, bat, glow, tock — the current tock task is
  visible in the tmux status bar.
- In a terminal `ls` is eza: icons, colours of the palette in both themes; pipes, scripts
  and tools get the plain `ls`.
- **`theme light` / `theme dark`** switches kitty, tmux and everything
  console at once; nvim and Claude Code need a restart.

## Repository layout

Configs live in [`files/`](files); the `Makefile` symlinks them by the
`LINKS` list and holds the rest of the targets: `install`, `check`, `fmt`,
`nvim-sync`, `clean`.
