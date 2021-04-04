augroup CustomAutocommands
  autocmd!
  
  " use absolute numbers in insert mode,
  " but relative in normal
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber

  " Do not draw signcolumn not in the editor
  autocmd FileType nerdtree,qf,diff setlocal signcolumn=no

  " call emmet by tab in html files
  autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
augroup END
