" move between splits with ctrl + h/j/k/l
" create split automatically if it is not exits
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

nnoremap S i<CR><Esc><right>
nnoremap <CR> :noh<CR><CR>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap * *N
nnoremap c* *Ncgn
