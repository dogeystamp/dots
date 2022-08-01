set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd ignorecase smartcase
set lazyredraw nocursorline ttyfast

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

highlight LineNr ctermfg=grey
highlight EndOfBuffer ctermfg=black ctermbg=black

" Disable highlighting when searching
nnoremap <silent> <esc> :noh<return><esc>


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

nnoremap - :call OpenNetRW()<cr>


" gdb integration

let g:termdebug_popup = 0
let g:termdebug_wide = 100

" Enter insert mode automatically in terminal windows
"au BufEnter term://* startinsert

au BufEnter *.c,*.cpp,*.h,*.hpp packadd termdebug

tnoremap <silent> <esc> <c-\><c-n><c-\><c-n>

nnoremap <silent> <f3> :Termdebug a.out<cr>
nnoremap <silent> <f4> :!g++ -g %:p<cr>
nnoremap <silent> <f5> :Run<cr>
nnoremap <silent> <f6> :Stop<cr>
nnoremap <silent> <f8> :Clear<cr>
nnoremap <silent> <f9> :Break<cr>
nnoremap <silent> <f10> :Continue<cr>

nnoremap <silent> <C-h> :vertical resize -5<cr>
nnoremap <silent> <C-l> :vertical resize +5<cr>
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W

nnoremap <silent> <c-p> :Step<cr>
nnoremap <silent> <c-n> :Over<cr>

vnoremap <silent> K :'<,'>Evaluate<cr>
