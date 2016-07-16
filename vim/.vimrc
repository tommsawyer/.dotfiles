" Plugins

call plug#begin('~/.vim/plugged')
        Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
        Plug 'Valloric/YouCompleteMe'
        Plug 'jiangmiao/auto-pairs'
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        Plug 'ctrlpvim/ctrlp.vim' 
        Plug 'easymotion/vim-easymotion'
        
        "Color schemes 
                Plug 'morhetz/gruvbox'
call plug#end()

" Common settings

colorscheme gruvbox
set background=dark
set number
set expandtab
set tabstop=4
syntax on

set hlsearch
set incsearch

" Key bindings
let g:mapleader=','
map <C-n> :NERDTreeToggle<CR>
map <Leader> <Plug>(easymoton-prefix)
