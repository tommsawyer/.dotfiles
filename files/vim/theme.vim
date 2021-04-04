set background=dark
" use vertical line for splits
set fillchars+=vert:┃

let g:gruvbox_invert_selection=0
colorscheme gruvbox

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

function! s:update_git_status()
  let g:airline_section_b = "%{get(g:,'coc_git_status','')}"
endfunction

let g:airline_section_b = "%{get(g:,'coc_git_status','')}"

autocmd User CocGitStatusChange call s:update_git_status()

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
