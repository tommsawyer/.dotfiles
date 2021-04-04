call plug#begin('~/.vim/plugged')
    " Project tree
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }

    " Multiple cursors
    Plug 'mg979/vim-visual-multi'
   
    " Fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Improving vim
    Plug 'tpope/vim-surround'   " surround text with brackets or tags
    Plug 'tpope/vim-unimpaired' " additional helpful shortcuts
    Plug 'tpope/vim-commentary' " commenting code
    Plug 'jiangmiao/auto-pairs' " automaticly insert brackets
    Plug 'wellle/targets.vim'   " additional text objects

    " Language support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'mattn/emmet-vim' 
    Plug 'janko/vim-test'
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
    Plug 'morhetz/gruvbox'                " main theme
    Plug 'vim-airline/vim-airline'        " statusline
    Plug 'vim-airline/vim-airline-themes' " themes for statusline
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

let g:highlightedyank_highlight_duration = 200

" let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
