" configurations for coding
" -------------------------

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

Plug 'stevearc/dressing.nvim'

Plug 'nvim-treesitter/nvim-treesitter'
" Code folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
"autocmd BufEnter * normal zR

" debugger interface atop many many abstractions
" (works on a lot of languages though!)
Plug 'puremourning/vimspector'
source $XDG_CONFIG_HOME/nvim/vimspector.vim

" bracket closing
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = "@@"

" improved error list
Plug 'folke/trouble.nvim'
nnoremap <leader>dxx <cmd>TroubleToggle<cr>
nnoremap <leader>dxw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>dxd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>dxq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>dxl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
