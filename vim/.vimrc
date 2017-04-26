" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree'                              " project tree
    Plug 'jiangmiao/auto-pairs'                             " automaticly insert brackets
    Plug 'tpope/vim-surround'                               " surround text with brackets or tags
    Plug 'godlygeek/tabular'                                " align text by symbol
    Plug 'tpope/vim-commentary'                             " comments
    Plug 'vim-airline/vim-airline'                          " status bar
    Plug 'powerman/vim-plugin-ruscmd'                       " normal mode mappings in russial layout
    Plug 'Shougo/vimproc.vim'
    Plug 'Shougo/unite.vim'                                 " find in project, run some cmds, etc
    Plug 'alvan/vim-closetag'                               " autoclose html tags
    Plug 'mhinz/vim-startify'                               " start screen
    Plug 'Chiel92/vim-autoformat'                           " autoformat code
    Plug 'vim-syntastic/syntastic'                          " check errors

    " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'

    " Snippets
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'
        Plug 'mattn/emmet-vim'

    " Autocompletion
        Plug 'Valloric/YouCompleteMe'

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'          " Jade
        Plug 'jelera/vim-javascript-syntax' " JS
        Plug 'elzr/vim-json'                " JSON
        Plug 'othree/html5-syntax.vim'      " HTML
        Plug 'leafgarland/typescript-vim'   " TypeScript
        Plug 'Valloric/MatchTagAlways'      " Highlight matching tags

    " IDE-like features
      Plug 'ternjs/tern_for_vim'
      Plug 'moll/vim-node'           " nodejs
      Plug 'Quramy/tsuquyomi'        " typescript
      Plug 'klen/python-mode'        " python
      Plug 'bdauria/angular-cli.vim' " angular 2 cli

    " Look
      " Color schemes
          Plug 'nanotech/jellybeans.vim'
      "Icons support
          Plug 'ryanoasis/vim-devicons'

call plug#end()

" Common settings
colorscheme jellybeans
set t_CO=256
syntax on
set encoding=utf8
set relativenumber
set number
set expandtab
set tabstop=2
set shiftwidth=2
set nobackup
set nowb
set noswapfile
set nocompatible
set hlsearch
set incsearch
filetype on
filetype plugin on
set scrolloff=5

autocmd InsertEnter * set norelativenumber
autocmd InsertLeave * set relativenumber

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Draw whitespaces
set list
set listchars=space:·,tab:▷\
highlight SpecialKey ctermbg=None ctermfg=237

" Do not draw whitespaces in nerdtree and quickfix
autocmd FileType nerdtree,qf setlocal nolist

" Remove trailing spaces before saving file
let blacklist = ['markdown'] " except markdown
autocmd BufWritePre * if index(blacklist, &ft) < 0 | RemoveTrailingSpaces

" Disable YouCompleteMe calling by tab to force ultisnips work well
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" Html matching tags color
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
highlight MatchTag ctermfg=lightblue ctermbg=234 guifg=black guibg=lightgreen

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

" Syntastic always show errors in quickfix
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1

" Key bindings
  let g:mapleader=','
  map <silent> <C-n> :NERDTreeToggle<CR>
  " Change buffer by ctrl + h,j,k,l
  map <C-j> <C-W>j
  map <C-k> <C-W>k
  map <C-h> <C-W>h
  map <C-l> <C-W>l
  " TypeScript Refactor Bindings
  autocmd FileType typescript nnoremap gd :TsuquyomiDefinition<CR>
  autocmd FileType typescript nnoremap gfr :TsuquyomiReferences<CR>
  autocmd FileType typescript nnoremap gr :TsuquyomiRenameSymbol<CR>
  " JavaScript Refactor Bindings
  autocmd FileType javascript nnoremap <silent> gd :TernDef<CR>:noh<CR>
  autocmd FileType javascript nnoremap gfr :TernRefs<CR>
  autocmd FileType javascript nnoremap gr :TernRename<CR>

  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-b>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"

  " call emmet by tab in html files
  autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

  noremap <Leader>o :<C-u>Unite -start-insert file_rec/async:!<CR>
  noremap <Leader>b :<C-u>Unite -start-insert buffer<CR>
  noremap <Leader>f :Unite grep:.<CR>
  noremap <silent> <Leader>q :cclose<CR>
  noremap <silent> <Leader>g :Unite -silent -start-insert menu:git<CR>
  noremap <Leader>t :Tabularize<Space>/
  noremap <silent> <Leader>n :noh<CR>

  " Switch buffers by left-right arrows
  nmap <Left> :bprevious<CR>
  nmap <Right> :bnext<CR>

  nmap <Leader>s :vsplit<CR>

  " Find in NerdTree
  nmap <silent> <Leader>a :NERDTreeFind<CR>

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

" Load Angular 2 cli plugin when @angular installed in node_modules
autocmd VimEnter * if globpath('.,..','node_modules/@angular') != '' | call angular_cli#init() | endif
