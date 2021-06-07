set background=dark
" use vertical line for splits
set fillchars+=vert:┃
set fillchars+=stl:━
set fillchars+=stlnc:━
set statusline=━

let g:gruvbox_invert_selection=0
colorscheme gruvbox

" make line between splits less visible
highlight VertSplit guifg=#32302f guibg=#282828

" remove '~' sign
highlight EndOfBuffer guifg=#282828 

" make signcolumn transparent
highlight SignColumn guibg=#282828

highlight CocErrorSign guibg=#282828 ctermfg=124
highlight CocWarningSign guibg=#282828
highlight CocInfoSign guibg=#282828

highlight CocFloating guibg=#3c3836
highlight Pmenu guibg=#3c3836

highlight Visual guibg=#3c3836
highlight HighlightedyankRegion guibg=#3c3836
highlight Search guifg='NONE' guibg=#3c3836 gui='NONE' term=None cterm=None
highlight IncSearch guibg=#504945 gui='NONE' cterm=None term=None
highlight DiffAdded guibg=#282828 guifg=#b8bb26
highlight DiffChanged guibg=#282828
highlight DiffRemoved guibg=#282828 guifg=#fb4934
highlight NERDTreeCWD guibg=#282828 guifg=#458588

highlight ConflictCurrent guifg=#3c3836
highlight ConflictIncoming guibg=#665c54

highlight StatusLine guibg=#32302f guifg=#282828
highlight StatusLineNC guibg=#32302f guifg=#282828
highlight CocMenuSel guifg='NONE' guibg=#3c3836 gui='NONE' cterm=None term=None
highlight PreviewMatch gui='BOLD' guibg='NONE' guifg='white' term=None cterm=None

highlight link OperatorSandwichBuns Visual
highlight link OperatorSandwichChange Visual
highlight link OperatorSandwichDelete Visual
highlight link OperatorSandwichAdd Visual
