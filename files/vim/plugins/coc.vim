let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-go', 'coc-snippets', 'coc-yaml', 'coc-vetur', 'coc-pyright', 'coc-tsserver']

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Show signature help on jump
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')


inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> gd  <Plug>(coc-definition)
nmap <silent> gy  <Plug>(coc-type-definition)
nmap <silent> gi  <Plug>(coc-implementation)
nmap <silent> gr  <Plug>(coc-rename)
nmap <silent> gfr <Plug>(coc-references-used)
nmap <silent> ga  <Plug>(coc-codeaction-cursor)
nmap <silent> ]d  <Plug>(coc-diagnostic-next)
nmap <silent> [d  <Plug>(coc-diagnostic-prev)
nmap <silent> ga  <Plug>(coc-codeaction-cursor)

nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <Leader>d :CocList symbols<CR>


xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
