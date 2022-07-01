set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

highlight LineNr ctermfg=grey
highlight EndOfBuffer ctermfg=black ctermbg=black

" Disable highlighting when searching
nnoremap <esc> :noh<return><esc>


" NetRW

set splitbelow splitright

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20

function! OpenNetRW()
	Vexplore
endfunction

aug netrw_close
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"|q|endif
aug END

nnoremap <tab> :wincmd w<cr>
nnoremap <s-tab> :wincmd W<cr>
inoremap <s-tab> <c-o>:wincmd W<cr>

nnoremap - :call OpenNetRW()<cr>


" gdb integration

let g:termdebug_popup = 0
let g:termdebug_wide = 100

tnoremap <tab> <c-\><c-n> :wincmd w<cr>
tnoremap <s-tab> <c-\><c-n> :wincmd W<cr>
tnoremap <esc> <c-\><c-n>

au BufEnter term://* startinsert
au BufEnter *.c,*.cpp,*.h,*.hpp packadd termdebug

nnoremap <f3> :Termdebug a.out<cr>
nnoremap <f4> :!g++ -g %:p<cr>
nnoremap <f5> :Run<cr>
nnoremap <s-f5> :Stop<cr>
nnoremap <f9> :Break<cr>
nnoremap <f8> :Clear<cr>
nnoremap <s-f10> :Continue<cr>
nnoremap <c-n> :Over<cr>
nnoremap <c-p> :Step<cr>
nnoremap <s-f11> :Finish<cr>
