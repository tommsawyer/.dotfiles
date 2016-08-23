" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " project tree
    Plug 'jiangmiao/auto-pairs'                             " automaticly insert brackets
    Plug 'ctrlpvim/ctrlp.vim'                               " fuzzy search
    Plug 'tpope/vim-surround'                               " surround text with brackets or tags
    Plug 'godlygeek/tabular'                                " align text by symbol
    Plug 'tpope/vim-commentary'                             " comments
    Plug 'mileszs/ack.vim'                                  " search in project 

    " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

    " Snippets
        Plug 'MarcWeber/vim-addon-mw-utils'
        Plug 'tomtom/tlib_vim'
        Plug 'garbas/vim-snipmate'
        Plug 'honza/vim-snippets'  

    " Autocompletion
        Plug 'Valloric/YouCompleteMe'

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'          " Jade
        Plug 'jelera/vim-javascript-syntax' " JS
        Plug 'elzr/vim-json'                " JSON

        Plug 'Shutnik/jshint2.vim'          " JSHint

    " Color schemes 
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
set nobackup
set nowb
set noswapfile
syntax on
set nocompatible
filetype on
filetype plugin on

" Draw whitespaces
set list
set listchars=space:·
highlight SpecialKey ctermbg=None ctermfg=236

set hlsearch
set incsearch

" Disable YouCompleteMe calling by tab to force snipmate work well
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" Key bindings
let g:mapleader=','
map <silent> <C-n> :NERDTreeToggle<CR>

" Change buffer by ctrl + h,j,k,l
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

imap <Tab> <Plug>snipMateNextOrTrigger
noremap <Leader>f :Ack!<Space>
noremap <Leader>t :Tabularize<Space>/
noremap <silent> <Leader>n :noh<CR>
