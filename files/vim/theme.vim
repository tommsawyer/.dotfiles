set background=dark
" use vertical line for splits
set fillchars+=vert:┃
set fillchars+=stl:━
set fillchars+=stlnc:━
set statusline=━

let g:gruvbox_invert_selection=0
colorscheme gruvbox

" make line between splits less visible
highlight VertSplit ctermfg=236 ctermbg=235

" remove '~' sign
highlight EndOfBuffer ctermfg=235 

" make signcolumn transparent
highlight SignColumn ctermbg=235

highlight CocErrorSign ctermbg=235 ctermfg=124
highlight CocWarningSign ctermbg=235
highlight CocInfoSign ctermbg=235

highlight CocFloating ctermbg=237
highlight Pmenu ctermbg=237

highlight HighlightedyankRegion ctermbg=237
highlight Visual ctermbg=237
highlight Search ctermbg=237 cterm=none ctermfg=none
highlight IncSearch ctermbg=66 cterm=none ctermfg=250
highlight DiffAdded ctermbg=235 ctermfg=106
highlight DiffChanged ctermbg=235 ctermfg=72
highlight DiffRemoved ctermbg=235 ctermfg=167
highlight NERDTreeCWD ctermbg=235 ctermfg=243

highlight ConflictCurrent ctermbg=237
highlight ConflictIncoming ctermbg=241

highlight StatusLine ctermbg=236 ctermfg=235
highlight StatusLineNC ctermbg=236 ctermfg=235
highlight CocMenuSel ctermbg=237 ctermfg=none
highlight PreviewMatch ctermbg=none ctermfg=167 cterm=bold

highlight link OperatorSandwichBuns Visual
highlight link OperatorSandwichChange Visual
highlight link OperatorSandwichDelete Visual
highlight link OperatorSandwichAdd Visual
