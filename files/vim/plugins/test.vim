nnoremap <silent> <Leader>tn :TestNearest<CR>
nnoremap <silent> <Leader>tl :TestLast<CR>
nnoremap <silent> <Leader>tf :TestFile<CR>
nnoremap <silent> <Leader>tv :TestVisit<CR>
nnoremap <silent> <Leader>ts :TestSuite<CR>
nnoremap <silent> <Leader>k :VtrKillRunner<CR>
nnoremap <silent> <Leader>l :VtrClearRunner<CR>

let test#strategy = "vtr"
augroup VTR
  autocmd!
  autocmd FileType sql vnoremap <buffer> <silent> <Leader>r :VtrSendLinesToRunner<CR>
  autocmd FileType sql nnoremap <buffer> <silent> <Leader>r :VtrSendLinesToRunner<CR>
  autocmd FileType sql nnoremap <buffer> <silent> <Leader>q :VtrSendCommand q<CR>
augroup END
