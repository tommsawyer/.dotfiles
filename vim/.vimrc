" Plugins
call plug#begin('~/.vim/plugged')
    " Common
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }           " project tree
    Plug 'w0rp/ale'                                                   " linter
    Plug 'jiangmiao/auto-pairs'                                       " automaticly insert brackets
    Plug 'tpope/vim-surround'                                         " surround text with brackets or tags
    Plug 'tpope/vim-commentary'                                       " comments
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'                                           " fuzzy finder
    Plug 'terryma/vim-multiple-cursors'                               " multiple cursors sublime-style
    Plug 'machakann/vim-highlightedyank'                              " highlight text on yank
    Plug 'AndrewRadev/splitjoin.vim'                                  " join or split struct/objects etc
    Plug 'tpope/vim-unimpaired'                                       " additional helpful shortcuts
    Plug 'wellle/targets.vim'                                         " additional text objects
    Plug 'KabbAmine/zeavim.vim'                                       " shortcuts for Zeal
    Plug 'christoomey/vim-tmux-runner'                                " integration with tmux
    Plug 'airblade/vim-gitgutter'                                     " show icons on editor left side; chunk preview/stage/undo
    " Snippets
    Plug 'Shougo/neosnippet.vim'                                      " snippet engine
    Plug 'tommsawyer/snippets'                                        " my snippets collection
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }     " completion engine
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    " Syntax highlighing
    Plug 'uarun/vim-protobuf'                                         " Protobuf
    Plug 'jelera/vim-javascript-syntax'                               " JS
    Plug 'elzr/vim-json'                                              " JSON
    Plug 'Valloric/MatchTagAlways'                                    " Highlight matching tags
    Plug 'ekalinin/Dockerfile.vim'                                    " Dockerfile
    Plug 'fatih/vim-go', { 'for' : 'go' }                             " golang tools
    " Look
    Plug 'nanotech/jellybeans.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
call plug#end()

let g:mapleader=','

" Common settings
colorscheme jellybeans
set background=dark
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
" set inccommand=split
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
set shell=/bin/zsh
" show suggestions when completing commands
set wildmenu
" do not show current mode, because it is displayed by airline
set noshowmode
filetype on
filetype plugin on
set scrolloff=5
set sidescrolloff=5
set updatetime=300
" type of vertical split characters
set fillchars+=vert:┃
set signcolumn=yes
set laststatus=2

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Draw whitespaces
set list
set listchars=space:·,tab:──
highlight SpecialKey ctermbg=None ctermfg=235

" Autocmds

augroup FollyAutocmds
  autocmd!

  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd FileType qf setlocal wrap
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber

  " Do not draw whitespaces not in the editor
  autocmd FileType nerdtree,qf,fugitiveblame,gitcommit,diff setlocal nolist
  autocmd FileType nerdtree,qf,fugitiveblame,gitcommit,diff setlocal signcolumn=no

  " Go Refactor Bindings
  autocmd FileType go nnoremap <silent> gd :GoDef<CR>:noh<CR>
  autocmd FileType go nnoremap gfr :GoReferrers<CR>
  autocmd FileType go nnoremap <Leader>i :GoImpl<Space>
  autocmd FileType go nnoremap gr :GoRename <Space>
  autocmd FileType go nnoremap <Leader>d :GoDeclsDir<CR>
  autocmd FileType go nnoremap <Leader>e :GoIfErr<CR>
  autocmd FileType go inoremap <Leader>e <C-o>:GoIfErr<CR>
  autocmd FileType go nnoremap <Leader>j :GoAddTags json<CR>
  autocmd FileType go nnoremap <silent> <Leader>r :call RunGoTestsInCurrentFolder()<CR>
  autocmd FileType go nnoremap <silent> <Leader>p :call RunGoTestsInProjectFolder()<CR>
  autocmd FileType go nnoremap <silent> <Leader>k :VtrKillRunner<CR>
  " make GoDoc comment
  autocmd FileType go nnoremap <Leader>c yiwO// <C-R>" 

  autocmd Filetype go
        \  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        \| command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        \| command! -bang AS call go#alternate#Switch(<bang>0, 'split')

  " call emmet by tab in html files
  autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
augroup END


" Plugin settings

" ALE
  let g:ale_sign_warning = ''
  let g:ale_sign_error = ''
  let g:ale_linters = {'go': ['staticcheck', 'gosimple']}
  let g:ale_go_staticcheck_lint_package=1

  nnoremap <silent> ]w :ALENextWrap<CR>zz
  nnoremap <silent> [w :ALEPreviousWrap<CR>zz

" highlighted yank
  let g:highlightedyank_highlight_duration = 200

" FZF
  " Key bindings
  " fuzzy-search in filenames
  noremap <Space> :Files<CR>
  " fuzzy-search in opened buffers
  noremap <Leader>b :Buffers<CR>
  " search text in project
  noremap <Leader>f :Ag<Space>
  let g:fzf_layout = { 'down': '~20%' }

"  GitGutter
    let g:gitgutter_sign_added=''
    let g:gitgutter_sign_modified = ''
    let g:gitgutter_sign_removed = ''

"  NERDTree
    let g:NERDTreeMinimalUI=1
    let g:NERDTreeDirArrowExpandable = ''
    let g:NERDTreeDirArrowCollapsible = ''
    let g:NERDTreeCascadeOpenSingleChildDir = 0
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeWinSize = 30
    let g:NERDTreeHijackNetrw=1
    map <silent> <Leader><Leader> :NERDTreeToggle<CR>
    nmap <silent> <Leader>a :NERDTreeFind<CR>

" Vim-go
  let g:go_snippet_engine = "neosnippet"
  let g:go_auto_type_info = 1
  let g:go_updatetime = 500
  let g:go_fmt_autosave = 1
  let g:go_fmt_command = "goimports"
  let g:go_info_mode = 'gopls'

"  Deoplete
    let g:deoplete#enable_at_startup = 1
    call deoplete#custom#option('omni_patterns', {
          \ 'go': '[^. *\t]\.\w*',
          \})

    " workaround using multiple cursors with deoplete
    function! Multiple_cursors_before()
      let b:deoplete_disable_auto_complete = 1
    endfunction

    function! Multiple_cursors_after()
      let b:deoplete_disable_auto_complete = 0
    endfunction

" Neosnippets
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
    imap <expr><TAB>
    \ pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    xmap <C-k> <Plug>(neosnippet_expand_target)

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

  " Jump between display lines with j/k too
  nnoremap k gk
  nnoremap j gj

  " S is shadowed by cc, so set it to smth useful
  nnoremap S i<CR><Esc><right>

  nnoremap <CR> :noh<CR><CR>

  nnoremap <Leader>h :Zeavim!<CR>

  iab rt return
  iab todo // TODO(tommsawyer):

nnoremap * *N
nnoremap c* *Ncgn

function! RunGoTestsInProjectFolder() 
  let project_folder = execute(":pwd")
  call VtrSendCommand("cd " . project_folder)
  call RunGoTestsInFolder("./...")
endfunction

function! RunGoTestsInCurrentFolder() 
  call RunGoTestsInFolder(expand('%:p:h'))
endfunction

function! RunGoTestsInFolder(folder)
  execute 'VtrOpenRunner'
  call VtrSendCommand("go test " . a:folder . " " . " -race ")
endfunction
