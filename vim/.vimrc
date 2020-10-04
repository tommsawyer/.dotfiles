" Plugins
call plug#begin('~/.vim/plugged')
    " Common
    Plug 'google/vim-maktaba'
    Plug 'google/vim-codefmt'
    Plug 'google/vim-glaive'
    Plug 'janko/vim-test'
    Plug 'mattn/emmet-vim' 
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }           " project tree
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
    Plug 'christoomey/vim-tmux-runner'                                " integration with tmux
    Plug 'airblade/vim-gitgutter'                                     " show icons on editor left side; chunk preview/stage/undo
    Plug 'honza/vim-snippets'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Syntax highlighing
    Plug 'chr4/nginx.vim'
    Plug 'uarun/vim-protobuf'                                         " Protobuf
    Plug 'chemzqm/vim-jsx-improve'
    Plug 'elzr/vim-json'                                              " JSON
    Plug 'Valloric/MatchTagAlways'                                    " Highlight matching tags
    Plug 'ekalinin/Dockerfile.vim'                                    " Dockerfile
    Plug 'fatih/vim-go', { 'for' : 'go'}                              " golang tools
    " Look
    Plug 'nanotech/jellybeans.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
call plug#end()

call glaive#Install()

let g:mapleader=','

let test#strategy = "vtr"

" Common settings
set background=dark
colorscheme jellybeans
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
set scrolloff=3
set sidescrolloff=3
set updatetime=300
" type of vertical split characters
set fillchars+=vert:┃
set signcolumn=yes
set laststatus=2
set timeoutlen=1000 ttimeoutlen=0

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Autocmds

augroup FollyAutocmds
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd FileType qf setlocal wrap
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber

  " Do not draw signcolumn not in the editor
  autocmd FileType nerdtree,qf,diff setlocal signcolumn=no

  " Go Refactor Bindings
  autocmd FileType go nnoremap <buffer> <Leader>i :GoImpl<Space>
  autocmd FileType go nnoremap <buffer> <Leader>d :GoDeclsDir<CR>
  autocmd FileType go nnoremap <buffer> <Leader>e :GoIfErr<CR>
  autocmd FileType go inoremap <buffer> <Leader>e <C-o>:GoIfErr<CR>
  autocmd FileType go nnoremap <buffer> <Leader>j :GoAddTags json<CR>
  autocmd FileType sql vnoremap <buffer> <silent> <Leader>r :VtrSendLinesToRunner<CR>
  autocmd FileType javascript vnoremap <buffer> <silent> <Leader>r :VtrSendLinesToRunner<CR>
  autocmd FileType sql nnoremap <buffer> <silent> <Leader>r :VtrSendLinesToRunner<CR>
  autocmd FileType sql nnoremap <buffer> <silent> <Leader>q :VtrSendCommand q<CR>
  nnoremap <silent> <Leader>k :VtrKillRunner<CR>
  nnoremap <silent> <Leader>l :VtrClearRunner<CR>
  " make GoDoc comment
  autocmd FileType go nnoremap <Leader>c yiwO// <C-R>" 

  autocmd Filetype go
        \  command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        \| command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        \| command! -bang AS call go#alternate#Switch(<bang>0, 'split')

  " call emmet by tab in html files
  autocmd FileType html,htmldjango imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

augroup END


" Plugin settings

" highlighted yank
  let g:highlightedyank_highlight_duration = 200

" FZF
  " Key bindings
  " fuzzy-search in filenames
  noremap <Space> :Files<CR>
  " fuzzy-search in opened buffers
  noremap <Leader>b :Buffers<CR>
  " search text in project
  noremap <Leader>f :Rg<Space>
  let g:fzf_layout = { 'down': '~40%' }

"  GitGutter
    let g:gitgutter_sign_added=''
    let g:gitgutter_sign_modified = ''
    let g:gitgutter_sign_removed = ''

"  NERDTree
    let g:NERDTreeIgnore=['\.git$', '__pycache__', '.vscode']
    let g:NERDTreeShowHidden=1
    let g:NERDTreeMinimalUI=1
    let g:NERDTreeDirArrowExpandable = "\u00a0"
    let g:NERDTreeDirArrowCollapsible = "\u00a0"
    let g:NERDTreeCascadeOpenSingleChildDir = 0
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeWinSize = 30
    let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
    let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
    map <silent> <Leader><Leader> :NERDTreeToggle<CR>
    nmap <silent> <Leader>a :NERDTreeFind<CR>

" Vim-go
  let g:go_auto_type_info = 1
  let g:go_updatetime = 500
  let g:go_fmt_autosave = 1
  let g:go_fmt_command = "goimports"
  let g:go_info_mode = 'gopls'
  let g:go_highlight_extra_types = 0
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_types = 0
  let g:go_highlight_operators = 1
  let g:go_highlight_format_strings = 1
  let g:go_highlight_function_calls = 1
  let g:go_doc_keywordprg_enabled = 0
  let g:go_def_mapping_enabled = 0
  
" Coc.nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <Leader>d :CocList symbols<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap gr <Plug>(coc-rename)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
" Neosnippets
    " let g:neosnippet#disable_runtime_snippets = {
    "   \   '_' : 1,
    "   \ }
    " let g:neosnippet#snippets_directory='~/.vim/plugged/snippets'

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

  iab {% <Delete>{% %}<Left><Left><Left>
  iab rt return
  iab todo // TODO(tommsawyer):

nnoremap * *N
nnoremap c* *Ncgn

highlight VertSplit ctermfg=234 ctermbg=233
highlight EndOfBuffer ctermfg=233

augroup nerdtreehidetirslashes
	autocmd!
	autocmd FileType nerdtree syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained
augroup end

augroup nerdtreehidecwd
	autocmd!
	autocmd FileType nerdtree setlocal conceallevel=3 | syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained
augroup end

let g:NERDTreeStatusline="FILES"
nnoremap <silent> <Leader>k :VtrKillRunner<CR>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'c'  : 'C',
      \ 'i'  : 'I',
      \ 'ic' : 'I',
      \ 'ix' : 'I',
      \ 'n'  : 'N',
      \ 'ni' : 'N',
      \ 'no' : 'N',
      \ 'R'  : 'R',
      \ 'Rv' : 'R',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ 't'  : 'T',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ }

" nnoremap <silent> <Leader>t "tyiw:let @t = TranslateWord("<C-r>"")<CR>viw"tp
" vnoremap <silent> <Leader>t "ty:let @t = trim(system("trans -b \"<C-r>"\""))<CR>gv"tp

nnoremap <silent> <Leader>tn :TestNearest<CR>
nnoremap <silent> <Leader>tl :TestLast<CR>
nnoremap <silent> <Leader>tf :TestFile<CR>
nnoremap <silent> <Leader>tv :TestVisit<CR>
nnoremap <silent> <Leader>ts :TestSuite<CR>

function! CamelCaseToWords(word)
  let word = ""
  let letters = split(a:word, '\zs') 
  let prevUpperCase = 0

  for c in letters
    if toupper(c) ==# c
      if prevUpperCase == 0
        let word = word . " " . tolower(c)
      else
        let word = word . tolower(c)
      endif

      let prevUpperCase = 1
    else
      let prevUpperCase = 0
      let word = word . c
    endif
  endfor

  return word
endfunction

function! WordsToCamelCase(uppercasefirst, word)
  let camelcased = substitute(a:word, ' \(\w\)', '\u\1\e', 'g')
  if a:uppercasefirst
    let camelcased = toupper(strcharpart(camelcased,0,1)) . strcharpart(camelcased, 1, len(camelcased) - 1)
  endif
  return camelcased
endfunction

function! TranslateWord(word)
  let uppercasefirst = (toupper(strcharpart(a:word, 0, 1)) ==# strcharpart(a:word, 0, 1))
  let words = CamelCaseToWords(a:word)
  let translated = trim(system("trans -b \"" . words . "\""))
  let lines = split(translated, '\n')
  let lastline = lines[len(lines) - 1]
  return WordsToCamelCase(uppercasefirst, lastline)
endfunction
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

augroup autoformat_settings
  autocmd FileType python AutoFormatBuffer black
  autocmd FileType html,htmldjango,css,sass,scss,less,json AutoFormatBuffer js-beautify
augroup end
