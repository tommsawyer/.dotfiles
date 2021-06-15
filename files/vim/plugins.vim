call plug#begin('~/.vim/plugged')

    " Project tree
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }

    " Fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Improving vim
    Plug 'machakann/vim-sandwich'          " surround text with brackets or tags
    Plug 'tpope/vim-unimpaired'            " additional helpful shortcuts
    Plug 'tpope/vim-commentary'            " commenting code
    Plug 'tmsvg/pear-tree'                 " automaticly insert brackets
    Plug 'wellle/targets.vim'              " additional text objects
    Plug 'christoomey/vim-system-copy'     " copy to system clipboard
    Plug 'ConradIrwin/vim-bracketed-paste' " no more :set paste

    " Language support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'mattn/emmet-vim' 
    Plug 'vim-test/vim-test'
    Plug 'AndrewRadev/splitjoin.vim'

    " Syntax highlighing
    Plug 'chr4/nginx.vim'          " Nginx
    Plug 'uarun/vim-protobuf'      " Protobuf
    Plug 'elzr/vim-json'           " JSON
    Plug 'ekalinin/Dockerfile.vim' " Dockerfile

    " Tmux integration
    Plug 'christoomey/vim-tmux-runner'
   
    " Themes
    Plug 'gruvbox-community/gruvbox'      " main theme
    Plug 'ryanoasis/vim-devicons'         " icons in nerdtree
    Plug 'machakann/vim-highlightedyank'  " highlight text on yank

call plug#end()

source ~/dotfiles/files/vim/plugins/nerdtree.vim
source ~/dotfiles/files/vim/plugins/test.vim
source ~/dotfiles/files/vim/plugins/coc.vim
source ~/dotfiles/files/vim/plugins/coc-git.vim
source ~/dotfiles/files/vim/plugins/fzf.vim
source ~/dotfiles/files/vim/plugins/highlightedyank.vim

let g:pear_tree_smart_openers = 0
let g:pear_tree_smart_closers = 0
let g:pear_tree_smart_backspace = 0
