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

" project-wide searching
Plug 'mileszs/ack.vim'
" close quickfix list after pressing enter
let g:ack_autoclose = 1
" Ack! does not jump to first result
nnoremap <Leader>/ :Ack!<Space>
" use ripgrep
let g:ackprg = 'rg --vimgrep --smart-case'


" debugger interface atop many many abstractions
" (works on a lot of languages though!)
Plug 'puremourning/vimspector'
source $XDG_CONFIG_HOME/nvim/vimspector.vim

" bracket closing
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = "@@"
