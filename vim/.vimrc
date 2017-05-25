" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree'            " project tree
    Plug 'jiangmiao/auto-pairs'           " automaticly insert brackets
    Plug 'tpope/vim-surround'             " surround text with brackets or tags
    Plug 'godlygeek/tabular'              " align text by symbol
    Plug 'tpope/vim-commentary'           " comments
    Plug 'vim-airline/vim-airline'        " status bar
    Plug 'vim-airline/vim-airline-themes' " status bar themes
    Plug 'Shougo/vimproc.vim'
    Plug 'Shougo/unite.vim'               " find in project, run some cmds, etc
    Plug 'tsukkee/unite-tag'              " unite ctags support
    Plug 'alvan/vim-closetag'             " autoclose html tags
    Plug 'mhinz/vim-startify'             " start screen
    Plug 'Chiel92/vim-autoformat'         " autoformat code
    Plug 'vim-syntastic/syntastic'        " check errors
    Plug 'terryma/vim-multiple-cursors'   " multiple cursors sublime-style

    " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        Plug 'tommcdo/vim-fubitive' " :Gbrowse for bitbucket
        Plug 'gregsexton/gitv'

    " Snippets
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets'
        Plug 'mattn/emmet-vim'

    " Autocompletion
        Plug 'Valloric/YouCompleteMe'

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'          " Jade
        Plug 'jelera/vim-javascript-syntax' " JS
        Plug 'isRuslan/vim-es6'             " JS es6
        Plug 'elzr/vim-json'                " JSON
        Plug 'othree/html5-syntax.vim'      " HTML
        Plug 'hail2u/vim-css3-syntax'       " CSS3
        Plug 'HerringtonDarkholme/yats.vim' " TypeScript
        Plug 'Valloric/MatchTagAlways'      " Highlight matching tags
        Plug 'tmhedberg/matchit'            " Extended % for html

    " IDE-like features
      Plug 'ternjs/tern_for_vim'
      Plug 'moll/vim-node'           " nodejs
      Plug 'Quramy/tsuquyomi'        " typescript
      Plug 'klen/python-mode'        " python
      Plug 'bdauria/angular-cli.vim' " angular 2 cli

      Plug 'majutsushi/tagbar'
      Plug 'craigemery/vim-autotag'  " ctags

    " Look
      " Color schemes
          Plug 'arcticicestudio/nord-vim'
      "Icons support
          Plug 'ryanoasis/vim-devicons'

call plug#end()

let g:mapleader=','

" Common settings
colorscheme nord
set nocompatible
set t_CO=256
syntax on
" add new vertical split in the right-hand side
set splitright
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
" delete comment character when joining commented lines
set formatoptions+=j
" show filename in terminal title
set title
" autoread file if it was changed on disk
set autoread
set shell=/bin/zsh
" show suggestions when completing commands
set wildmenu
filetype on
filetype plugin on
set scrolloff=5
set sidescrolloff=5

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
  let trailing_spaces_blacklist = ['markdown'] " except markdown
  autocmd BufWritePre * if index(trailing_spaces_blacklist, &ft) < 0 | RemoveTrailingSpaces

  " TypeScript Refactor Bindings
  autocmd FileType typescript nnoremap gd :TsuquyomiDefinition<CR>
  autocmd FileType typescript nnoremap gfr :TsuquyomiReferences<CR>
  autocmd FileType typescript nnoremap gr :TsuquyomiRenameSymbol<CR>

  " JavaScript Refactor Bindings
  autocmd FileType javascript nnoremap <silent> gd :TernDef<CR>:noh<CR>
  autocmd FileType javascript nnoremap gfr :TernRefs<CR>
  autocmd FileType javascript nnoremap gr :TernRename<CR>
  "
  " Python Refactor Bindings
  autocmd FileType python nnoremap <silent> gd :call pymode#rope#goto_definition()<CR>
  autocmd FileType python nnoremap <silent> gfr :call pymode#rope#find_it()<CR>
  autocmd FileType python nnoremap <silent> gr :call pymode#rope#rename()<CR>

  " Refactoring menu
  autocmd FileType typescript nnoremap <silent> <Leader>r :Unite -silent -start-insert menu:typescript_refactoring<CR>
  autocmd FileType javascript nnoremap <silent> <Leader>r :Unite -silent -start-insert menu:javascript_refactoring<CR>

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
      " fuzzy-search in filenames
        noremap <Leader>o :<C-u>Unite -start-insert file_rec/async:!<CR>
      " fuzzy-search in opened buffers
        noremap <Leader>b :<C-u>Unite -start-insert buffer<CR>
      " fuzzy-search tags
        noremap <Leader>z :<C-u>Unite -start-insert tag<CR>
      " search text in project
        noremap <Leader>f :Unite grep:.<CR>
      " git menu
        noremap <silent> <Leader>g :Unite -silent -start-insert menu:git<CR>
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

        let g:unite_source_menu_menus.typescript_refactoring = {
            \'description': '  TypeScript Refactoring'
            \}
        let g:unite_source_menu_menus.typescript_refactoring.command_candidates = [
                    \['    rename', 'TsuquyomiRenameSymbol'],
                    \['    show referencies', 'TsuquyomiReferences'],
                    \['    go to definition', 'TsuquyomiDefinition'],
                    \['    import', 'TsuquyomiImport']
                    \]

        let g:unite_source_menu_menus.javascript_refactoring = {
            \'description': '  JavaScript Refactoring'
            \}
        let g:unite_source_menu_menus.javascript_refactoring.command_candidates = [
                    \['    rename', 'TernRename'],
                    \['    show referencies', 'TernRef'],
                    \['    go to definition', 'TernDef'],
                    \]

" TsuQuyomi
    " use single quotes on import
    let g:tsuquyomi_single_quote_import = 1

"  NERDTree
    let g:NERDTreeMinimalUI=1
    let g:NERDTreeDirArrowExpandable = ''
    let g:NERDTreeDirArrowCollapsible = ''
    let g:NERDTreeCascadeOpenSingleChildDir = 0
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeWinSize = 35
    map <silent> <Leader><Leader> :NERDTreeToggle<CR>
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

" Python Mode
  let g:pymode_folding = 0

" Key bindings

  " Change buffer by ctrl + h,j,k,l
  noremap <C-j> <C-W>j
  noremap <C-k> <C-W>k
  noremap <C-h> <C-W>h
  noremap <C-l> <C-W>l

  noremap <silent> <Leader>q :cclose<CR>
  noremap <silent> <Leader>t :Tabularize<Space>/
  noremap <silent> <Leader>n :noh<CR>
  nnoremap <silent> <Leader>s :vsplit<CR>
  nnoremap <silent> <Leader>x :TagbarToggle<CR>

  " Jump between display lines with j/k too
  nnoremap k gk
  nnoremap j gj

  " Resize vertical split by Ctrl + up/down
  nnoremap <C-up> 7<C-w>>
  nnoremap <C-down> 7<C-w><

  " S is shadowed by cc, so set it to smth useful
  nnoremap S i<CR><Esc><right>

  " Move up/down visual selection by K/J
  vnoremap K :m '<-2<CR>gv=gv
  vnoremap J :m '>+1<CR>gv=gv
