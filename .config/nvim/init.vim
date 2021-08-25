set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd noruler
set guifont=JetBrains\ Mono:h16

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

let g:neovide_cursor_animation_length=0.13

highlight LineNr ctermfg=grey
highlight EndOfBuffer ctermfg=black ctermbg=black

map <F1> :FloatermToggle<CR>
tnoremap <F1> <C-\><C-n>:FloatermToggle<CR>

call plug#begin()
Plug 'voldikss/vim-floaterm'
Plug 'ycm-core/youcompleteme'
call plug#end()

tnoremap <C-w> <C-\><C-n>
