brew-bundle:
	brew bundle

vim-install-vimplug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim-install-plugins:
	vim +PlugInstall +qall

vim-update-plugins:
	vim +PlugUpdate +qall

vim-clean-plugins:
	vim +PlugClean +qall

symlinks:
	ln -s ~/dotfiles/files/zshrc ~/.zshrc
	ln -s ~/dotfiles/files/vimrc ~/.vimrc
	ln -s ~/dotfiles/files/tmux.conf ~/.tmux.conf
	ln -s ~/dotfiles/files/vim/coc-settings.json ~/.vim/coc-settings.json

oh-my-zsh:
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > ohmyzsh.sh
	sh ohmyzsh.sh
	rm ohmyzsh.sh

clean:
	rm ~/.zshrc ~/.vimrc ~/.tmux.conf ~/.vim/coc-settings.json

install: brew-bundle oh-my-zsh vim-install-vimplug symlinks vim-plugins-install
