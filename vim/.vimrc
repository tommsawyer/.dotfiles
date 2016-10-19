" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " project tree
    Plug 'jiangmiao/auto-pairs'                             " automaticly insert brackets
    Plug 'ctrlpvim/ctrlp.vim'                               " fuzzy search
    Plug 'tpope/vim-surround'                               " surround text with brackets or tags
    Plug 'godlygeek/tabular'                                " align text by symbol
    Plug 'tpope/vim-commentary'                             " comments
    Plug 'vim-airline/vim-airline'                          " status bar
    Plug 'powerman/vim-plugin-ruscmd'                       " normal mode mappings in russial layout
    Plug 'Shougo/vimproc.vim'
    Plug 'Shougo/unite.vim'                                 " find in project, run some cmds, etc

    " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

    " Snippets
        Plug 'MarcWeber/vim-addon-mw-utils'
        Plug 'tomtom/tlib_vim'
        Plug 'garbas/vim-snipmate'
        Plug 'honza/vim-snippets'  
        Plug 'matthewsimo/angular-vim-snippets'

    " Autocompletion
        Plug 'Valloric/YouCompleteMe'

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'          " Jade
        Plug 'jelera/vim-javascript-syntax' " JS
        Plug 'elzr/vim-json'                " JSON
        Plug 'kchmck/vim-coffee-script'     " CoffeeScript
        Plug 'klen/python-mode'             " Python
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
set number
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
set scrolloff=5

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
"
" Status bar settings
let g:airline_enable_fugitive=1
let g:airline_fugitive_prefix = '⎇ '
let g:airline_section_c = '%t'

" Unite settings
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10
let g:unite_candidate_icon="▷"

" Unite menus

let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
let g:unite_source_menu_menus.git = {
    \'description': 'Git commands'
    \}

let g:unite_source_menu_menus.git.command_candidates = [
            \['>>  Git status (Fugitive)', 'Gstatus'],
            \['>>  Git log    (Fugitive)', 'Glog']
            \]


" Key bindings
let g:mapleader=','
map <silent> <C-n> :NERDTreeToggle<CR>

" Change buffer by ctrl + h,j,k,l
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

imap <Tab> <Plug>snipMateNextOrTrigger

" convert indentation to spaces
noremap <silent> <Leader>s ggVG:s/\t/\ \ \ \ /g<CR>:noh<CR>
" convert indentation to tabs
noremap <silent> <Leader>S ggVG:s/\ \ \ \ /\t/g<CR>:noh<CR>

noremap <F5> :!node %<CR>
noremap <Leader>o :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/async:!<CR>
noremap <Leader>f :Unite grep:.<CR>
noremap <silent> <Leader>g :Unite -silent -start-insert menu:git<CR>
noremap <Leader>t :Tabularize<Space>/
noremap <silent> <Leader>q :UniteClose<CR>
noremap <silent> <Leader>n :noh<CR>
