nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
nmap <Leader>gi <Plug>(coc-git-chunkinfo)
nmap <Leader>gc <Plug>(coc-git-commit)
nmap <silent> <Leader>gu :CocCommand git.chunkUndo<CR>

hi! DiffAdded ctermbg=235 ctermfg=106
hi! DiffChanged ctermbg=235 ctermfg=72
hi! DiffRemoved ctermbg=235 ctermfg=167
