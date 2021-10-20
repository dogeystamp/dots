set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

highlight LineNr ctermfg=grey
highlight EndOfBuffer ctermfg=black ctermbg=black

call plug#begin()
Plug 'ycm-core/youcompleteme'
call plug#end()
