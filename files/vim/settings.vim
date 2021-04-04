let g:mapleader=','

set shell=/bin/zsh
set nocompatible
set hidden
syntax on
" add new vertical split in the right-hand side
set splitright
set splitbelow
set encoding=utf8
set nostartofline
set relativenumber
set number
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround
set smarttab

" no swaps and backups, use git instead
set nobackup
set nowb
set noswapfile

" highlight search word, rerun when typing
set hlsearch
set incsearch

" ignore case when searching, but dont ignore when search word contains uppercase
set ignorecase
set smartcase

set backspace=indent,eol,start
" global regexps by default
set gdefault
" delete comment character when joining commented lines, insert on enter/o
set formatoptions+=jro
" show filename in terminal title
set title
" autoread file if it was changed on disk
set autoread
" show suggestions when completing commands
set wildmenu
" do not show current mode, because it is displayed by airline
set noshowmode
filetype on
filetype plugin on
set scrolloff=3
set sidescrolloff=3
set updatetime=300
" type of vertical split characters
set signcolumn=yes
set laststatus=2
set timeoutlen=1000 ttimeoutlen=0

let g:go_highlight_trailing_whitespace_error=0
