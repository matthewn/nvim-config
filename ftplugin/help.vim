" better navigation for vim help
" taken from _Hacking Vim_ by Kim Shultz (Packt Publishing), p. 56

" jump to links with return
nmap <buffer> <CR> <C-]>
" jump back with backspace
nmap <buffer> <BS> <C-T>
" skip to next option link
nmap <buffer> o /'[a-z]\{2,\}'<CR>
" skip to previous option link
nmap <buffer> O ?'[a-z]\{2,\}'<CR>
" skip to next subject link
nmap <buffer> s /\|\S\+\|<CR>l
" skip to previous subject link
nmap <buffer> S h?\|\S\+\|<CR>l
" skip to next/prev quickfix list entry (from a helpgrep)
nmap <buffer> <leader>j :cnext<CR>
nmap <buffer> <leader>k :cprev<CR>

