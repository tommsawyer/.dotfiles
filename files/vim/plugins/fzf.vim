let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --hidden --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* RgExact
      \ call fzf#vim#grep(
      \   'rg --column --hidden --line-number --no-heading --color=always --smart-case --fixed-strings -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)

" fuzzy-search in filenames
noremap <silent> <Space> :Files<CR>
" fuzzy-search in opened buffers
noremap <silent> <Leader>b :Buffers<CR>
" search text in project
noremap <silent> <Leader>f :Rg<CR>
" search my todo's
noremap <silent> <Leader>t :RgExact TODO(demaksimov):<CR>
vnoremap <silent> <Leader>f y:Rg <C-R>"<CR>
