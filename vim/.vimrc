" Plugins

call plug#begin('~/.vim/plugged')
        Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
        Plug 'Valloric/YouCompleteMe'
        Plug 'jiangmiao/auto-pairs'
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        Plug 'ctrlpvim/ctrlp.vim' 
        Plug 'tpope/vim-surround'
        Plug 'godlygeek/tabular'
        Plug 'jelera/vim-javascript-syntax'        
        Plug 'MarcWeber/vim-addon-mw-utils'
        Plug 'tomtom/tlib_vim'
        Plug 'garbas/vim-snipmate'
        Plug 'honza/vim-snippets'  

        "Color schemes 
                Plug 'nanotech/jellybeans.vim'
                Plug 'morhetz/gruvbox'
call plug#end()

" Common settings
set t_CO=256
set background=dark
colorscheme jellybeans
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
syntax on
set nocompatible
filetype on
filetype plugin on

set hlsearch
set incsearch

" Disable YouCompleteMe calling by tab to force snipmate work well
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" Key bindings
let g:mapleader=','
map <C-n> :NERDTreeToggle<CR>

" Change buffer by ctrl + h,j,k,l
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
imap <Tab> <Plug>snipMateNextOrTrigger
