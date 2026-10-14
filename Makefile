install: brew npm oh-my-zsh symlinks

brew:
	brew bundle --file=files/Brewfile

npm:
	npm install -g @olrtg/emmet-language-server

oh-my-zsh:
	[ -d ~/.oh-my-zsh ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

symlinks:
	mkdir -p ~/.config
	@for f in ~/.zshrc ~/.tmux.conf ~/.config/nvim; do \
		if [ -e $$f ] && [ ! -L $$f ]; then mv $$f $$f.backup && echo "backed up $$f"; fi; \
	done
	ln -sfn ~/.dotfiles/files/nvim ~/.config/nvim
	ln -sfn ~/.dotfiles/files/zshrc ~/.zshrc
	ln -sfn ~/.dotfiles/files/tmux.conf ~/.tmux.conf

nvim-sync:
	nvim --headless "+Lazy! sync" +qa

clean:
	rm -f ~/.zshrc ~/.tmux.conf ~/.config/nvim

.PHONY: install brew npm oh-my-zsh symlinks nvim-sync clean
