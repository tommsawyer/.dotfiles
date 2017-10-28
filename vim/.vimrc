" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree'            " project tree
    Plug 'jiangmiao/auto-pairs'           " automaticly insert brackets
    Plug 'tpope/vim-surround'             " surround text with brackets or tags
    Plug 'godlygeek/tabular'              " align text by symbol
    Plug 'tpope/vim-commentary'           " comments
    Plug 'vim-airline/vim-airline'        " status bar
    Plug 'vim-airline/vim-airline-themes' " status bar themes
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'alvan/vim-closetag'             " autoclose html tags
    Plug 'mhinz/vim-startify'             " start screen
    Plug 'Chiel92/vim-autoformat'         " autoformat code
    Plug 'vim-syntastic/syntastic'        " check errors
    Plug 'terryma/vim-multiple-cursors'   " multiple cursors sublime-style
    Plug 'editorconfig/editorconfig-vim'  " http://editorconfig.org

    " Git
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        Plug 'tommcdo/vim-fubitive'         " :Gbrowse for bitbucket
        Plug 'github.com/tpope/vim-rhubarb' " :Gbrowse for github

    " Snippets
        Plug 'Shougo/neosnippet.vim'
        Plug 'Shougo/neosnippet-snippets'
        Plug 'mattn/emmet-vim'

    " Autocompletion
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        Plug 'carlitux/deoplete-ternjs'
        Plug 'mhartington/nvim-typescript'
        Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
        Plug 'zchee/deoplete-go', { 'do': 'make'}

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
      Plug 'geekjuice/vim-mocha'
      Plug 'fatih/vim-go'
      Plug 'moll/vim-node'           " nodejs
      Plug 'Quramy/tsuquyomi'        " typescript
      Plug 'bdauria/angular-cli.vim' " angular 2 cli

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
" delete comment character when joining commented lines
set formatoptions+=j
" show filename in terminal title
set title
" autoread file if it was changed on disk
set autoread
set shell=/bin/zsh
" show suggestions when completing commands
set wildmenu
" do not show current mode, because it is displayed by airline
set noshowmode
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
set listchars=space:·,tab:>>
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

  " Go Refactor Bindings
  autocmd FileType go nnoremap <silent> gd :GoDef<CR>:noh<CR>
  autocmd FileType go nnoremap gfr :GoReferrers<CR>
  autocmd FileType go nnoremap gr :GoRename<CR>

  " Autoclose preview window
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

  " call emmet by tab in html files
  autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

  " Load Angular 2 cli plugin when @angular installed in node_modules
  autocmd VimEnter * if globpath('.,..','node_modules/@angular') != '' | call angular_cli#init() | endif
augroup END


" Plugin settings

"Mocha
  let g:mocha_js_command = "!NODE_ENV=test mocha --recursive {spec}"
  nmap <Leader>mc :call RunCurrentSpecFile()<CR>
  nmap <Leader>mn :call RunNearestSpec()<CR>

" QuickRun
  let g:quickrun_config = {
      \'*': {
      \'outputter/buffer/split': ':10split'},}
  noremap <silent> <F5> :QuickRun<CR>

function! IsGitRepo()
  let status = system('git status')
  return status !~ "fatal"
endfunction

" FZF
  " Key bindings
    " fuzzy-search in filenames
    if IsGitRepo()
      noremap <Leader>o :GFiles<CR>
    else
      noremap <Leader>o :Files<CR>
    endif

    " fuzzy-search in opened buffers
    noremap <Leader>b :Buffers<CR>
    " search text in project
    noremap <Leader>f :Ag<Space>

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
  let g:syntastic_javascript_checkers = ['eslint']
  let g:syntastic_go_checkers = ['']

" Vim-go
  let g:go_snippet_engine = "neosnippet"
  let g:go_metalinter_autosave = 1

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

"  Deoplete
    let g:deoplete#enable_at_startup = 1
    let g:tern_request_timeout = 1
    let g:tern#command = ["tern"]
    let g:tern#arguments = ["--persistent"]

" Neocomplete
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    imap <expr><TAB>
    \ pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    xmap <C-l> <Plug>(neosnippet_expand_target)
" Neosnippets
    let g:neosnippet#enable_snipmate_compatibility = 1

    " For conceal markers.
    if has('conceal')
      set conceallevel=2 concealcursor=niv
    endif

"  MatchTagAlways
  " Color of matching tags
    let g:mta_use_matchparen_group = 0
    let g:mta_set_default_matchtag_color = 0
    highlight MatchTag ctermfg=lightblue ctermbg=23 guifg=black guibg=lightgreen

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

  " Jump between display lines with j/k too
  nnoremap k gk
  nnoremap j gj

  nnoremap <silent> <F7> :Autoformat<CR>
  nnoremap <silent> <F9> :GoBuild<CR>

  " Resize vertical split by Ctrl + up/down
  nnoremap <C-up> 7<C-w>>
  nnoremap <C-down> 7<C-w><

  " S is shadowed by cc, so set it to smth useful
  nnoremap S i<CR><Esc><right>

  " Move up/down visual selection by K/J
  vnoremap K :m '<-2<CR>gv=gv
  vnoremap J :m '>+1<CR>gv=gv
  let g:go_fmt_command = "goimports"


  "console.log macro
  let @l = '_iconsole.log(lx$pa;=='
