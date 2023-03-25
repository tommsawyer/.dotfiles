symlinks:
	ln -s ~/.dotfiles/files/nvim ~/.config
	ln -s ~/.dotfiles/files/zshrc ~/.zshrc
	ln -s ~/.dotfiles/files/tmux.conf ~/.tmux.conf

oh-my-zsh:
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > ohmyzsh.sh
	sh ohmyzsh.sh
	rm ohmyzsh.sh

clean:
	rm -rf ~/.zshrc ~/.tmux.conf ~/.config/nvim

install: oh-my-zsh symlinks 
