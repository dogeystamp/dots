" configurations for coding
" -------------------------

" Code folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" unfold by default
set foldlevel=99

source $XDG_CONFIG_HOME/nvim/vimspector.vim

" auto-pairs
let g:AutoPairsFlyMode = 0
