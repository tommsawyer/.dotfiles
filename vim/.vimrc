" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree'                              " project tree
    Plug 'jiangmiao/auto-pairs'                             " automaticly insert brackets
    Plug 'tpope/vim-surround'                               " surround text with brackets or tags
    Plug 'godlygeek/tabular'                                " align text by symbol
    Plug 'tpope/vim-commentary'                             " comments
    Plug 'vim-airline/vim-airline'                          " status bar
    Plug 'vim-airline/vim-airline-themes'                   " status bar themes
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
        Plug 'gregsexton/gitv'

    " Snippets
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'
        Plug 'isRuslan/vim-es6'
        Plug 'mattn/emmet-vim'

    " Autocompletion
        Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'          " Jade
        Plug 'jelera/vim-javascript-syntax' " JS
        Plug 'elzr/vim-json'                " JSON
        Plug 'othree/html5-syntax.vim'      " HTML
        Plug 'hail2u/vim-css3-syntax'       " CSS3
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
          Plug 'arcticicestudio/nord-vim'
      "Icons support
          Plug 'ryanoasis/vim-devicons'

call plug#end()

" Common settings
colorscheme nord
set t_CO=256
syntax on
set encoding=utf8
set nostartofline
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
set gdefault
set title
filetype on
filetype plugin on
set scrolloff=5
set guitablabel=\[%N\]\ %f

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Draw whitespaces
set list
set listchars=space:·,tab:▷\
highlight SpecialKey ctermbg=None ctermfg=243

" Autocmds
augroup HoldenAutocmds
  autocmd!

  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber

  " Do not draw whitespaces not in the editor
  autocmd FileType nerdtree,qf,fugitiveblame,gitcommit setlocal nolist

  " Remove trailing spaces before saving file
  let blacklist = ['markdown'] " except markdown
  autocmd BufWritePre * if index(blacklist, &ft) < 0 | RemoveTrailingSpaces

  " TypeScript Refactor Bindings
  autocmd FileType typescript nnoremap gd :TsuquyomiDefinition<CR>
  autocmd FileType typescript nnoremap gfr :TsuquyomiReferences<CR>
  autocmd FileType typescript nnoremap gr :TsuquyomiRenameSymbol<CR>

  " JavaScript Refactor Bindings
  autocmd FileType javascript nnoremap <silent> gd :TernDef<CR>:noh<CR>
  autocmd FileType javascript nnoremap gfr :TernRefs<CR>
  autocmd FileType javascript nnoremap gr :TernRename<CR>

  " call emmet by tab in html files
  autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

  " Load Angular 2 cli plugin when @angular installed in node_modules
  autocmd VimEnter * if globpath('.,..','node_modules/@angular') != '' | call angular_cli#init() | endif
augroup END


" Plugin settings

"  Unite
    let g:unite_source_grep_command="ag" " ag is much faster than grep
    let g:unite_source_grep_default_opts="--nogroup --nocolor --ignore='.git' --ignore='node_modules'"
    let g:unite_enable_start_insert = 1
    let g:unite_split_rule = "botright"
    let g:unite_force_overwrite_statusline = 0
    let g:unite_winheight = 10
    " Enable fuzzy search
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
    " Ignore node_modules
        call unite#custom#source('file_rec,file_rec/async', 'ignore_pattern', './node_modules/')
    " Key bindings
        noremap <Leader>o :<C-u>Unite -start-insert file_rec/async:!<CR>     " fuzzy-search in filenames
        noremap <Leader>b :<C-u>Unite -start-insert buffer<CR>               " fuzzy-search in opened buffers
        noremap <Leader>f :Unite grep:.<CR>                                  " search text in project
        noremap <silent> <Leader>g :Unite -silent -start-insert menu:git<CR> " git menu
    " Menus
        let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
        let g:unite_source_menu_menus.git = {
            \'description': '  Git commands'
            \}
        let g:unite_source_menu_menus.git.command_candidates = [
                    \['    status', 'Gstatus'],
                    \['    blame ', 'Gblame'],
                    \['    diff  ', 'Gdiff'],
                    \['    log   ', 'Glog']
                    \]

"  NERDTree
    let g:NERDTreeMinimalUI=1
    let g:NERDTreeDirArrowExpandable = ''
    let g:NERDTreeDirArrowCollapsible = ''
    let g:NERDTreeCascadeOpenSingleChildDir = 0
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeWinSize = 35
    map <silent> <C-n> :NERDTreeToggle<CR>
    nmap <silent> <Leader>a :NERDTreeFind<CR>

"  YouCompleteMe
  " Disable YouCompleteMe calling by tab to force ultisnips work well
    let g:ycm_key_list_select_completion=[]
    let g:ycm_key_list_previous_completion=[]
  " Autoclose docs after completion
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_autoclose_preview_window_after_insertion = 1

"  Airline
  " Always show airline status bar
    set laststatus=2
  " Use powerline fonts
    let g:airline_powerline_fonts = 1
  let g:airline_enable_fugitive=1
  let g:airline_fugitive_prefix = '⎇ '
  let g:airline_section_c = '%t'

"  Syntastic
  " Syntastic always show errors in quickfix
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
  let g:syntastic_html_checkers = ['htmlhint']

"  Startify
  let g:startify_change_to_dir = 0
  let g:startify_files_number = 8
  let g:startify_bookmarks = ['~/.vimrc']
  let g:startify_custom_header =
      \ map(split(system('fortune ~/.vim/fortunes | cowsay -W 100'), '\n'), '"   ". v:val') + ['','']
  let g:startify_list_order = [
        \ 'bookmarks',
        \ ['      Recently edited files in current directory:'],
        \ 'dir',
        \ ['      Recently edited files:'],
        \ 'files'
        \ ]

"  UltiSnips
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-b>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"  MatchTagAlways
  " Color of matching tags
    let g:mta_use_matchparen_group = 0
    let g:mta_set_default_matchtag_color = 0
    highlight MatchTag ctermfg=lightblue ctermbg=23 guifg=black guibg=lightgreen

" Key bindings
let g:mapleader=','

" Change buffer by ctrl + h,j,k,l
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

noremap <silent> <Leader>q :cclose<CR>
noremap <Leader>t :Tabularize<Space>/
noremap <silent> <Leader>n :noh<CR>

" Switch buffers by left-right arrows
nmap <silent> <Left> :bprevious<CR>
nmap <silent> <Right> :bnext<CR>
nmap <Leader>s :vsplit<CR>
nnoremap k gk
nnoremap j gj
