call plug#begin('~/.vim/plugged')
    " Project tree
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }

    " Multiple cursors
    Plug 'mg979/vim-visual-multi'
   
    " Fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Improving vim
    Plug 'machakann/vim-sandwich'       " surround text with brackets or tags
    Plug 'tpope/vim-unimpaired'         " additional helpful shortcuts
    Plug 'tpope/vim-commentary'         " commenting code
    Plug 'jiangmiao/auto-pairs'         " automaticly insert brackets
    Plug 'wellle/targets.vim'           " additional text objects
    Plug 'jeetsukumaran/vim-indentwise' " indent-based motions

    " Language support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'mattn/emmet-vim' 
    Plug 'vim-test/vim-test'
    Plug 'AndrewRadev/splitjoin.vim'

    " Code formatting
    Plug 'google/vim-maktaba' " codefmt dependency
    Plug 'google/vim-glaive'  " codefmt dependency
    Plug 'google/vim-codefmt' " autoformat code

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


    Plug 'takac/vim-hardtime'
call plug#end()

call glaive#Install()

source ~/dotfiles/files/vim/plugins/nerdtree.vim
source ~/dotfiles/files/vim/plugins/test.vim
source ~/dotfiles/files/vim/plugins/coc.vim
source ~/dotfiles/files/vim/plugins/coc-git.vim
source ~/dotfiles/files/vim/plugins/fzf.vim
source ~/dotfiles/files/vim/plugins/autoformat.vim
source ~/dotfiles/files/vim/plugins/highlightedyank.vim

" let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
