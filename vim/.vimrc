" Plugins

call plug#begin('~/.vim/plugged')

    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }           " project tree
    Plug 'w0rp/ale'                                                   " linter
    Plug 'jiangmiao/auto-pairs'                                       " automaticly insert brackets
    Plug 'godlygeek/tabular'                                          " align text by symbol
    Plug 'tpope/vim-surround'                                         " surround text with brackets or tags
    Plug 'tpope/vim-commentary'                                       " comments
    Plug 'tpope/vim-eunuch'                                           " unix helpers
    Plug 'vim-airline/vim-airline'                                    " status bar
    Plug 'vim-airline/vim-airline-themes'                             " status bar themes
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'                                           " fuzzy finder
    Plug 'alvan/vim-closetag'                                         " autoclose html tags
    Plug 'mhinz/vim-startify'                                         " start screen
    Plug 'Chiel92/vim-autoformat'                                     " autoformat code
    Plug 'terryma/vim-multiple-cursors'                               " multiple cursors sublime-style
    Plug 'editorconfig/editorconfig-vim'                              " http://editorconfig.org
    Plug 'machakann/vim-highlightedyank'                              " highlight text on yank
    Plug 'AndrewRadev/splitjoin.vim'                                  " join or split struct/objects etc

    " Git
        Plug 'tpope/vim-fugitive'     " git core for vim
        Plug 'jreybert/vimagit'       " better git committing
        Plug 'airblade/vim-gitgutter' " show icons on editor left side
        Plug 'tommcdo/vim-fubitive'   " :Gbrowse for bitbucket
        Plug 'tpope/vim-rhubarb'      " :Gbrowse for github

    " Snippets
        Plug 'Shougo/neosnippet.vim'                            " snippet engine
        Plug 'tommsawyer/snippets'                              " my snippets collection
        Plug 'mattn/emmet-vim', {'for': ['html', 'javascript']} " emmet-like behaviour for html

    " Autocompletion
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }                               " completion engine
        Plug 'carlitux/deoplete-ternjs'                                                             " javascript completion
        Plug 'mhartington/nvim-typescript'                                                          " typescript completion
        Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' } " golang completion daemon
        Plug 'zchee/deoplete-go', { 'do': 'make'}                                                   " golang completion

    " Syntax highlighing
        Plug 'digitaltoad/vim-pug'             " Jade
        Plug 'jelera/vim-javascript-syntax'    " JS
        Plug 'isRuslan/vim-es6'                " JS es6
        Plug 'elzr/vim-json'                   " JSON
        Plug 'othree/html5-syntax.vim'         " HTML
        Plug 'hail2u/vim-css3-syntax'          " CSS3
        Plug 'HerringtonDarkholme/yats.vim'    " TypeScript
        Plug 'Valloric/MatchTagAlways'         " Highlight matching tags
        Plug 'tmhedberg/matchit'               " Extended % for html
        Plug 'ekalinin/Dockerfile.vim'         " Dockerfile
        Plug 'martinda/Jenkinsfile-vim-syntax' " Jenkinsfile

    " IDE-like features
      Plug 'ternjs/tern_for_vim', { 'for': 'javascript' } " javascript
      Plug 'fatih/vim-go', { 'for' : 'go' }               " golang tools
      Plug 'godoctor/godoctor.vim', { 'for' : 'go' }      " golang refactoring
      Plug 'moll/vim-node'                                " nodejs tools
      Plug 'Quramy/tsuquyomi'                             " typescript tools

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
" nvim feature, preview :%s command
set inccommand=split
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
set updatetime=800
" type of vertical split characters
set fillchars+=vert:┃ 

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Draw whitespaces
set list
set listchars=space:·,tab:──
highlight SpecialKey ctermbg=None ctermfg=243

" Autocmds

augroup HoldenAutocmds
  autocmd!

  autocmd FileType qf setlocal wrap
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber

  " Do not draw whitespaces not in the editor
  autocmd FileType nerdtree,qf,fugitiveblame,gitcommit setlocal nolist

  " Remove trailing spaces before saving file
  let trailing_spaces_blacklist = ['markdown', 'vim'] " exceptions
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
  autocmd FileType go vnoremap ge :GoRefactor extract<Space>
  autocmd FileType go vnoremap gt :GoRefactor toggle<CR>
  autocmd FileType go vnoremap gv :GoRefactor var<Space>

  autocmd FileType go nnoremap <Leader>d :GoDeclsDir<CR>
  autocmd Filetype go
        \  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        \| command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        \| command! -bang AS call go#alternate#Switch(<bang>0, 'split')

  " call emmet by tab in html files
  autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
augroup END


" Plugin settings

" Vimagit
  let g:magit_default_sections = ['commit', 'staged', 'unstaged']

" highlighted yank
  let g:highlightedyank_highlight_duration = 200

" FZF
  " Key bindings
  " fuzzy-search in filenames
  noremap <Leader>o :Files<CR>
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

    let g:airline_powerline_fonts = 1
    let g:airline_enable_fugitive=1
    let g:airline_fugitive_prefix = '⎇ '
    let g:airline_mode_map = {
          \ '__' : '-',
          \ 'n'  : 'N',
          \ 'i'  : 'I',
          \ 'R'  : 'R',
          \ 'c'  : 'C',
          \ 'v'  : 'V',
          \ 'V'  : 'V',
          \ 's'  : 'S',
          \ 'S'  : 'S',
          \ }

" Vim-go
  let g:go_snippet_engine = "neosnippet"
  let g:go_auto_type_info = 1
  let g:go_updatetime = 500
  let g:go_fmt_autosave = 1
  let g:go_fmt_command = "goimports"

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

    " workaround using multiple cursors with deoplete
    function! Multiple_cursors_before()
      let b:deoplete_disable_auto_complete = 1
    endfunction

    function! Multiple_cursors_after()
      let b:deoplete_disable_auto_complete = 0
    endfunction

" Neocomplete
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    imap <expr><TAB>
    \ pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    xmap <C-k> <Plug>(neosnippet_expand_target)

" Neosnippets
    let g:neosnippet#disable_runtime_snippets = {
      \   '_' : 1,
      \ }
    let g:neosnippet#snippets_directory='~/.vim/plugged/snippets'

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
  func! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
      if (match(a:key,'[jk]'))
        wincmd v
      else
        wincmd s
      endif
      exec "wincmd ".a:key
    endif
  endfu
 
  nnoremap <silent> <C-h> :call WinMove('h')<CR>
  nnoremap <silent> <C-j> :call WinMove('j')<CR>
  nnoremap <silent> <C-k> :call WinMove('k')<CR>
  nnoremap <silent> <C-l> :call WinMove('l')<CR>

  noremap <silent> <Leader>t :Tabularize<Space>/
  noremap <silent> <Leader>n :noh<CR>

  " Jump between display lines with j/k too
  nnoremap k gk
  nnoremap j gj

  nnoremap <silent> <F7> :Autoformat<CR>
  nnoremap <silent> <F9> :GoBuild<CR>

  " Resize vertical split by Ctrl + up/down
  nnoremap <C-up> 7<C-w>>
  nnoremap <C-down> 7<C-w><

  nnoremap <Up> :lprev<CR>
  nnoremap <Down> :lnext<CR>

  " S is shadowed by cc, so set it to smth useful
  nnoremap S i<CR><Esc><right>

  " Move up/down visual selection by K/J
  vnoremap K :m '<-2<CR>gv=gv
  vnoremap J :m '>+1<CR>gv=gv

