# paths are taken from wherever the repo is cloned
DOTFILES := $(CURDIR)
LAZYGIT_DIR := $(HOME)/Library/Application Support/lazygit
ITERM_PROFILES_DIR := $(HOME)/Library/Application Support/iTerm2/DynamicProfiles
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

npm:
	# into ~/.local, not the global npm prefix: that one may be root-owned (EACCES)
	npm install -g --prefix "$(HOME)/.local" @olrtg/emmet-language-server

oh-my-zsh:
	[ -d "$(HOME)/.oh-my-zsh" ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

symlinks:
	mkdir -p "$(HOME)/.config" "$(LAZYGIT_DIR)" "$(ITERM_PROFILES_DIR)"
	$(call link,$(DOTFILES)/files/zshrc,$(HOME)/.zshrc)
	$(call link,$(DOTFILES)/files/tmux.conf,$(HOME)/.tmux.conf)
	$(call link,$(DOTFILES)/files/nvim,$(HOME)/.config/nvim)
	$(call link,$(DOTFILES)/files/bat,$(HOME)/.config/bat)
	$(call link,$(DOTFILES)/files/lazygit/config.yml,$(LAZYGIT_DIR)/config.yml)
	$(call link,$(DOTFILES)/files/iterm/tokyonight.json,$(ITERM_PROFILES_DIR)/tokyonight.json)
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

clean:
	rm -f "$(HOME)/.zshrc" "$(HOME)/.tmux.conf" "$(HOME)/.config/nvim" "$(HOME)/.config/bat" "$(LAZYGIT_DIR)/config.yml" "$(ITERM_PROFILES_DIR)/tokyonight.json"
	-git config --global --fixed-value --unset-all include.path "$(DELTA_CONFIG)"

.PHONY: install homebrew brew npm oh-my-zsh symlinks spell nvim-sync clean
