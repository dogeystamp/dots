" configurations for coding
" -------------------------

" Code folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" unfold by default
set foldlevel=99

" auto-pairs
let g:AutoPairsFlyMode = 0
