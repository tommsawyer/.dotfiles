let g:NERDTreeIgnore=['\.git$', '__pycache__', '.vscode']
let g:NERDTreeShowHidden=0
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
let g:NERDTreeCascadeOpenSingleChildDir = 0
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeWinSize = 35
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""

map <silent> <Leader><Leader> :NERDTreeToggle<CR>
nmap <silent> <Leader>a :NERDTreeFind<CR>

augroup nerdtreehidedirslashes
	autocmd!
	autocmd FileType nerdtree syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained
augroup end
