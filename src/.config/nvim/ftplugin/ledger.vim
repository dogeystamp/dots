" see https://plaintextaccounting.org/ for more info

let g:ledger_date_format = '%Y-%m-%d'
let g:ledger_maxwidth = 80
let g:ledger_fillstring = '·'
let g:ledger_default_commodity = '$'
let g:ledger_align_at = 50
nnoremap <leader>tc :call ledger#transaction_state_toggle(line('.'))<CR>
nnoremap <leader>tt :call ledger#transaction_date_set(line('.'), 'unshift')<CR>
inoremap <silent> <buffer> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
vnoremap <silent> <buffer> <Tab> :LedgerAlign<CR>
