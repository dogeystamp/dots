set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu laststatus=0
set guifont=JetBrains\ Mono:h16

hi Search cterm=NONE ctermfg=white ctermbg=blue

let g:neovide_cursor_animation_length=0.13

highlight LineNr ctermfg=grey
highlight EndOfBuffer ctermfg=black ctermbg=black

map <F1> :FloatermToggle<CR>
tnoremap <F1> <C-\><C-n>:FloatermToggle<CR>

call plug#begin()
Plug 'voldikss/vim-floaterm'
call plug#end()

tnoremap <C-w> <C-\><C-n>
