" configurations for coding
" -------------------------

" Code folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
"autocmd BufEnter * normal zR

source $XDG_CONFIG_HOME/nvim/vimspector.vim

" auto-pairs
let g:AutoPairsFlyMode = 0

" trouble.nvim
nnoremap <leader>dxx <cmd>TroubleToggle<cr>
nnoremap <leader>dxw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>dxd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>dxq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>dxl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
