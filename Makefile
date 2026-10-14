install: brew npm oh-my-zsh symlinks spell

brew:
	brew bundle --file=files/Brewfile

npm:
	npm install -g @olrtg/emmet-language-server

oh-my-zsh:
	[ -d ~/.oh-my-zsh ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

symlinks:
	mkdir -p ~/.config
	@for f in ~/.zshrc ~/.tmux.conf ~/.config/nvim ~/.config/bat; do \
		if [ -e $$f ] && [ ! -L $$f ]; then mv $$f $$f.backup && echo "backed up $$f"; fi; \
	done
	ln -sfn ~/.dotfiles/files/nvim ~/.config/nvim
	ln -sfn ~/.dotfiles/files/zshrc ~/.zshrc
	ln -sfn ~/.dotfiles/files/tmux.conf ~/.tmux.conf
	ln -sfn ~/.dotfiles/files/bat ~/.config/bat
	mkdir -p ~/Library/Application\ Support/lazygit
	ln -sfn ~/.dotfiles/files/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
	bat cache --build

spell:
	mkdir -p ~/.local/share/nvim/site/spell
	cd ~/.local/share/nvim/site/spell && for f in ru.utf-8.spl ru.utf-8.sug; do \
		[ -f $$f ] || curl -fsSLO https://ftp.nluug.nl/pub/vim/runtime/spell/$$f; \
	done

nvim-sync:
	nvim --headless "+Lazy! sync" +qa

clean:
	rm -f ~/.zshrc ~/.tmux.conf ~/.config/nvim ~/.config/bat ~/Library/Application\ Support/lazygit/config.yml

.PHONY: install brew npm oh-my-zsh symlinks spell nvim-sync clean
