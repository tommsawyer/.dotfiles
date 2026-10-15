# paths are taken from wherever the repo is cloned
DOTFILES := $(CURDIR)
LAZYGIT_DIR := $(HOME)/Library/Application Support/lazygit
ITERM_PROFILES_DIR := $(HOME)/Library/Application Support/iTerm2/DynamicProfiles
K9S_DIR := $(HOME)/Library/Application Support/k9s
DELTA_CONFIG := $(DOTFILES)/files/git/delta.gitconfig

# on a fresh mac brew is not on PATH yet, and each recipe line is a new shell
BREW_PREFIX := $(shell [ "$$(uname -m)" = arm64 ] && echo /opt/homebrew || echo /usr/local)
export PATH := $(BREW_PREFIX)/bin:$(PATH)

# $(call link,source,target): symlink target -> source, moving a real file away to *.backup
define link
	@if [ -e "$(2)" ] && [ ! -L "$(2)" ]; then mv "$(2)" "$(2).backup" && echo "backed up $(2)"; fi
	ln -sfn "$(1)" "$(2)"
endef

install: homebrew brew npm oh-my-zsh symlinks spell

homebrew:
	@command -v brew >/dev/null 2>&1 || \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew:
	brew bundle --file="$(DOTFILES)/files/Brewfile"

# into ~/.local, not the global npm prefix: that one may be root-owned (EACCES)
npm:
	npm install -g --prefix "$(HOME)/.local" @olrtg/emmet-language-server

oh-my-zsh:
	[ -d "$(HOME)/.oh-my-zsh" ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

symlinks:
	mkdir -p "$(HOME)/.config" "$(HOME)/.local/bin" "$(LAZYGIT_DIR)" "$(ITERM_PROFILES_DIR)" "$(K9S_DIR)/skins"
	$(call link,$(DOTFILES)/files/zshrc,$(HOME)/.zshrc)
	$(call link,$(DOTFILES)/files/tmux.conf,$(HOME)/.tmux.conf)
	$(call link,$(DOTFILES)/files/tmux/switch.sh,$(HOME)/.local/bin/tmux-switch)
	$(call link,$(DOTFILES)/files/nvim,$(HOME)/.config/nvim)
	$(call link,$(DOTFILES)/files/bat,$(HOME)/.config/bat)
	$(call link,$(DOTFILES)/files/lazygit/config.yml,$(LAZYGIT_DIR)/config.yml)
	$(call link,$(DOTFILES)/files/k9s/config.yaml,$(K9S_DIR)/config.yaml)
	$(call link,$(DOTFILES)/files/k9s/skins/kanagawa.yaml,$(K9S_DIR)/skins/kanagawa.yaml)
	$(call link,$(DOTFILES)/files/iterm/profile.json,$(ITERM_PROFILES_DIR)/dotfiles.json)
	# drop dangling links left from renamed profiles, iTerm complains about them on start
	@find "$(ITERM_PROFILES_DIR)" -type l ! -exec test -e {} \; -print -delete
	bat cache --build
	git config --global --get-all include.path | grep -qxF "$(DELTA_CONFIG)" || \
		git config --global --add include.path "$(DELTA_CONFIG)"

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
	@echo "tmux"; tmux -L dotfiles-check -f /dev/null new-session -d \; source-file files/tmux.conf; \
		rc=$$?; tmux -L dotfiles-check kill-server 2>/dev/null; exit $$rc
	@echo "sh"; shellcheck files/tmux/*.sh
	@echo "yaml"; ruby -ryaml -e 'ARGV.each { |f| YAML.load_file(f, aliases: true) }' \
		files/lazygit/config.yml files/k9s/config.yaml files/k9s/skins/kanagawa.yaml
	@echo "lua"; lua-language-server --check="$(DOTFILES)/files/nvim" --configpath="$(DOTFILES)/.luarc.json" \
		--checklevel=Warning >/dev/null || { echo "run it without >/dev/null to see the problems"; exit 1; }
	@# goes through ~/.config/nvim, so needs `make symlinks`; startup errors are printed, silenced ones are not
	@echo "nvim"; out=$$(nvim --headless +qa 2>&1); [ -z "$$out" ] || { echo "$$out"; exit 1; }
	@echo "all good"

clean:
	rm -f "$(HOME)/.zshrc" "$(HOME)/.tmux.conf" "$(HOME)/.local/bin/tmux-switch" "$(HOME)/.config/nvim" "$(HOME)/.config/bat" "$(LAZYGIT_DIR)/config.yml" "$(K9S_DIR)/config.yaml" "$(K9S_DIR)/skins/kanagawa.yaml" "$(ITERM_PROFILES_DIR)/dotfiles.json"
	-git config --global --fixed-value --unset-all include.path "$(DELTA_CONFIG)"

.PHONY: install homebrew brew npm oh-my-zsh symlinks spell nvim-sync check clean
