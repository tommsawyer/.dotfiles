# paths are taken from wherever the repo is cloned
DOTFILES := $(CURDIR)
LAZYGIT_DIR := $(HOME)/Library/Application Support/lazygit
ITERM_PROFILES_DIR := $(HOME)/Library/Application Support/iTerm2/DynamicProfiles
K9S_DIR := $(HOME)/Library/Application Support/k9s
DELTA_CONFIG := $(DOTFILES)/files/git/delta.gitconfig

# on a fresh mac brew is not on PATH yet, and each recipe line is a new shell
BREW_PREFIX := $(shell [ "$$(uname -m)" = arm64 ] && echo /opt/homebrew || echo /usr/local)
export PATH := $(BREW_PREFIX)/bin:$(PATH)

# what `make symlinks` links and `make clean` removes: one "file in the repo|link" per line
define LINKS
files/zshrc|$(HOME)/.zshrc
files/hushlogin|$(HOME)/.hushlogin
files/tmux|$(HOME)/.config/tmux
files/nvim|$(HOME)/.config/nvim
files/kitty|$(HOME)/.config/kitty
files/bat|$(HOME)/.config/bat
files/theme|$(HOME)/.config/theme
files/theme/theme|$(HOME)/.local/bin/theme
files/lazygit/config.yml|$(LAZYGIT_DIR)/config.yml
files/lazygit/light.yml|$(LAZYGIT_DIR)/light.yml
files/k9s/config.yaml|$(K9S_DIR)/config.yaml
files/k9s/skins/onedark-warmer.yaml|$(K9S_DIR)/skins/onedark-warmer.yaml
files/k9s/skins/onedark-light.yaml|$(K9S_DIR)/skins/onedark-light.yaml
files/iterm/profile.json|$(ITERM_PROFILES_DIR)/dotfiles.json
files/claude/settings.json|$(HOME)/.claude/settings.json
endef
export LINKS

install: homebrew brew npm symlinks terminfo iterm spell bookokrat

homebrew:
	@command -v brew >/dev/null 2>&1 || \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew:
	brew bundle --file="$(DOTFILES)/files/Brewfile"

# into ~/.local, not the global npm prefix: that one may be root-owned (EACCES)
npm:
	npm install -g --prefix "$(HOME)/.local" @olrtg/emmet-language-server

symlinks:
	mkdir -p "$(HOME)/.config" "$(HOME)/.local/bin" "$(HOME)/.claude" "$(LAZYGIT_DIR)" "$(ITERM_PROFILES_DIR)" "$(K9S_DIR)/skins"
	@# a real file in the way is moved to *.backup
	@printf '%s\n' "$$LINKS" | while IFS='|' read -r src dst; do \
		if [ -e "$$dst" ] && [ ! -L "$$dst" ]; then mv "$$dst" "$$dst.backup" && echo "backed up $$dst"; fi; \
		ln -sfn "$(DOTFILES)/$$src" "$$dst" && echo "$$dst -> $$src"; \
	done
	# drop dangling links left from renamed profiles, iTerm complains about them on start
	@find "$(ITERM_PROFILES_DIR)" -type l ! -exec test -e {} \; -print -delete
	bat cache --build
	git config --global --get-all include.path | grep -qxF "$(DELTA_CONFIG)" || \
		git config --global --add include.path "$(DELTA_CONFIG)"

# the system tic: ~/.terminfo is read by the system ncurses too, and brew's tic writes a format it may not read
terminfo:
	/usr/bin/tic -x -o "$(HOME)/.terminfo" "$(DOTFILES)/files/tmux/tmux-256color.terminfo"

# global prefs, a profile cannot hold them; iTerm picks them up on restart
iterm:
	@# Minimal theme: the title bar and tabs take the terminal background
	defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5

# bookokrat writes its config.yaml itself, so not a link: the onedark themes go in place of
# its custom_themes section (to the end of the file) and theme: is set to the current one
BOOKOKRAT_CONFIG := $(HOME)/.config/bookokrat/config.yaml
bookokrat:
	mkdir -p "$(dir $(BOOKOKRAT_CONFIG))"
	@[ -f "$(BOOKOKRAT_CONFIG)" ] || printf 'version: 3\ntheme: ""\n' >"$(BOOKOKRAT_CONFIG)"
	@# the section runs to the next top-level key; blank lines at the end are dropped and the
	@# header comment of themes.yaml is not copied, so that a second run changes nothing
	@. files/theme/env.sh && { \
		awk '/^custom_themes:/ { skip = 1; next } skip && /^[^ \t#]/ { skip = 0 } skip { next } \
			/^$$/ { blank++; next } { for (; blank; blank--) print ""; print }' "$(BOOKOKRAT_CONFIG)" | \
			sed "s/^theme: .*/theme: \"$$thm_bookokrat\"/"; \
		echo; sed '/^#/d' files/bookokrat/themes.yaml; \
	} >"$(BOOKOKRAT_CONFIG).tmp" && mv "$(BOOKOKRAT_CONFIG).tmp" "$(BOOKOKRAT_CONFIG)"

spell:
	mkdir -p "$(HOME)/.local/share/nvim/site/spell"
	cd "$(HOME)/.local/share/nvim/site/spell" && for f in ru.utf-8.spl ru.utf-8.sug; do \
		[ -f $$f ] || curl -fsSLO https://ftp.nluug.nl/pub/vim/runtime/spell/$$f; \
	done

nvim-sync:
	nvim --headless "+Lazy! sync" +qa

# fast sanity checks for the configs, run after changing them
check:
	@echo "zsh"; zsh -n files/zshrc
	@# a throwaway server: -n only parses and misses unknown options
	@echo "tmux"; tmux -L dotfiles-check -f /dev/null new-session -d \; source-file files/tmux/tmux.conf; \
		rc=$$?; tmux -L dotfiles-check kill-server 2>/dev/null; exit $$rc
	@echo "sh"; shellcheck -x files/tmux/*.sh files/theme/theme files/theme/env.sh
	@echo "yaml"; ruby -ryaml -e 'ARGV.each { |f| YAML.load_file(f, aliases: true) }' \
		files/lazygit/config.yml files/lazygit/light.yml files/k9s/config.yaml files/k9s/skins/*.yaml files/bookokrat/themes.yaml
	@echo "json"; jq empty files/claude/settings.json
	@# load_config only warns about unknown keys, so any output is a failure
	@echo "kitty"; out=$$(kitty +runpy 'import sys; from kitty.config import load_config; \
		load_config(sys.argv[-1])' files/kitty/kitty.conf 2>&1); [ -z "$$out" ] || { echo "$$out"; exit 1; }
	@echo "lua"; lua-language-server --check="$(DOTFILES)/files/nvim" --configpath="$(DOTFILES)/.luarc.json" \
		--checklevel=Warning >/dev/null || { echo "run it without >/dev/null to see the problems"; exit 1; }
	@# goes through ~/.config/nvim, so needs `make symlinks`; startup errors are printed, silenced ones are not
	@echo "nvim"; out=$$(nvim --headless +qa 2>&1); [ -z "$$out" ] || { echo "$$out"; exit 1; }
	@echo "all good"

# lua_ls has no formatting cli: open each file in nvim and save it, conform formats through lua_ls
fmt:
	@nvim --headless +'lua for _, f in ipairs(vim.fn.globpath("files/nvim", "**/*.lua", false, true)) do \
		vim.cmd.edit(f); \
		assert(vim.wait(10000, function() return #vim.lsp.get_clients({ bufnr = 0, name = "lua_ls" }) > 0 end), "lua_ls did not attach"); \
		vim.cmd("silent write") end' +qa

clean:
	@printf '%s\n' "$$LINKS" | while IFS='|' read -r _ dst; do [ ! -L "$$dst" ] || rm "$$dst"; done
	-git config --global --fixed-value --unset-all include.path "$(DELTA_CONFIG)"

.PHONY: install homebrew brew npm symlinks terminfo iterm spell bookokrat nvim-sync check fmt clean
