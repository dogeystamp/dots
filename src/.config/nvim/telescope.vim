Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-lua/plenary.nvim', { 'branch': '0.1.x' }

nnoremap <leader>ef <cmd>Telescope find_files<cr>
nnoremap <leader>eg <cmd>Telescope live_grep<cr>
nnoremap <leader>em <cmd>Telescope buffers<cr>
nnoremap <leader>eh <cmd>Telescope help_tags<cr>
nnoremap <leader>es <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>eb <cmd>Telescope keymaps<cr>
