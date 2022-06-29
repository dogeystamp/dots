set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

highlight LineNr ctermfg=grey
highlight EndOfBuffer ctermfg=black ctermbg=black

nnoremap <esc> :noh<return><esc>

set splitbelow splitright

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20

function! OpenNetRW()
	Vexplore
	wincmd l
endfunction

aug ProjectDrawer
  au!
  au VimEnter * :call OpenNetRW()
aug END

aug netrw_close
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"|q|endif
aug END

nnoremap <tab> :wincmd w<cr>
inoremap <tab> <c-o>:wincmd w<cr>
nnoremap <s-tab> :wincmd W<cr>
inoremap <s-tab> <c-o>:wincmd W<cr>
