" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " project tree
    Plug 'ivalkeen/nerdtree-execute'
    Plug 'jiangmiao/auto-pairs'                             " automaticly insert brackets
    Plug 'tpope/vim-surround'                               " surround text with brackets or tags
    Plug 'godlygeek/tabular'                                " align text by symbol
    Plug 'tpope/vim-commentary'                             " comments
    Plug 'vim-airline/vim-airline'                          " status bar
    Plug 'powerman/vim-plugin-ruscmd'                       " normal mode mappings in russial layout
    Plug 'Shougo/vimproc.vim'
    Plug 'Shougo/unite.vim'                                 " find in project, run some cmds, etc
    Plug 'justinmk/vim-sneak'                               " easymotion alternative
    Plug 'moll/vim-node'

    " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

    " Snippets
        Plug 'MarcWeber/vim-addon-mw-utils'
        Plug 'tomtom/tlib_vim'
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'  
        Plug 'matthewsimo/angular-vim-snippets'
        Plug 'tisho/css-snippets-snipmate'
        Plug 'mattn/emmet-vim'

    " Autocompletion
        Plug 'Valloric/YouCompleteMe'

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'          " Jade
        Plug 'jelera/vim-javascript-syntax' " JS
        Plug 'elzr/vim-json'                " JSON
        Plug 'klen/python-mode'             " Python
        Plug 'leafgarland/typescript-vim'   " TypeScript
        Plug 'Quramy/tsuquyomi'

    " Color schemes 
        Plug 'nanotech/jellybeans.vim'
        Plug 'morhetz/gruvbox'
        Plug '29decibel/codeschool-vim-theme'
        Plug 'altercation/vim-colors-solarized'

call plug#end()

" Common settings
colorscheme jellybeans
set t_CO=256
syntax on
set relativenumber
set number
set expandtab
set tabstop=2
set shiftwidth=2
set nobackup
set nowb
set noswapfile
set nocompatible
filetype on
filetype plugin on
set scrolloff=5
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Draw whitespaces
set list
set listchars=space:·,tab:▷\ 
highlight SpecialKey ctermbg=None ctermfg=237

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
" Enable fuzzy search
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" Ignore node_modules
call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern', './node_modules/')

" Unite menus

let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})

let g:unite_source_menu_menus.git = {
    \'description': 'Git commands'
    \}

let g:unite_source_menu_menus.git.command_candidates = [
            \['>>  Git status (Fugitive)', 'Gstatus'],
            \['>>  Git blame  (Fugitive)', 'Gblame'],
            \['>>  Git diff   (Fugitive)', 'Gdiff'],
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

noremap <F5> :!node %<CR>
noremap <Leader>o :<C-u>Unite -start-insert file_rec/async:!<CR>
noremap <Leader>b :<C-u>Unite -start-insert buffer<CR>
noremap <Leader>f :Unite grep:.<CR>
noremap <silent> <Leader>g :Unite -silent -start-insert menu:git<CR>
noremap <Leader>t :Tabularize<Space>/
noremap <silent> <Leader>n :noh<CR>

nmap <Left> :bprevious<CR>
nmap <Right> :bnext<CR>
nmap <Leader>s :vsplit<CR>

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

nmap <Leader>i :TsuImport <CR>

nmap <Leader>a :NERDTreeFind<CR>

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#263238')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#263238')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#263238')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#263238')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#263238')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#263238')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#263238')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#263238')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#263238')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#263238')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#263238')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#263238')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#263238')
call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#263238')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#263238')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#263238')
call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#263238')
call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#263238')
