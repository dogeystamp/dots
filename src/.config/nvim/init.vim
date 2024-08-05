set tabstop=4 shiftwidth=4 noexpandtab ai nosmd ignorecase smartcase

" visible whitespace
set list listchars=tab:»\ ,trail:•,leadmultispace:\│\ \ \ ,extends:⇥,precedes:⇤

" Time neovim saves to swapfile in
" Also time neovim recognizes cursor inactivity
set updatetime=800

" terminal settings
" disable line numbers
au TermOpen * setlocal nonumber norelativenumber
" make ESC go to normal mode
tnoremap <silent> <esc> <c-\><c-n><c-\><c-n>

" sign column on top of the line number (gutter for things like breakpoints, warnings)
" this can be an issue because it blocks line numbers
" set scl=number

" enable line numbers
set number relativenumber

" disable bottom right status line
set noruler
set showtabline=0

" performance?
set lazyredraw nocursorline ttyfast

" disable splash screen
set shortmess+=I

let mapleader = ","
let maplocalleader = " "

" " use system clipboard instead of internal
" set clipboard=unnamedplus
" " when using c or s, do not overwrite clipboard
" nnoremap c "-c
" vnoremap c "-c
" nnoremap s "-s
" vnoremap s "-s

" easier binds to use system clipboard with
nmap <C-S>y "+y
vmap <C-S>y "+y
nmap <C-S>d "+d
vmap <C-S>d "+d
nmap <C-S>c "+c
vmap <C-S>c "+c
nmap <C-S>p "+p

" 0 is easier to reach so swap these binds
nnoremap 0 ^
nnoremap ^ 0
vnoremap 0 ^
vnoremap ^ 0

set shell=/bin/sh

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic
hi SignColumn ctermbg=NONE

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

highlight LineNr ctermfg=grey

" Disable highlighting when searching
nnoremap <silent> <esc> :noh<return><esc>

" tab, window management
set splitbelow splitright
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
nnoremap <silent> <C-h> :vertical resize -5<cr>
nnoremap <silent> <C-l> :vertical resize +5<cr>
" exit all (akin to ZZ, ZQ)
nnoremap <silent> ZF :qa<cr>

" see .config/nvim/lua/init.lua
lua require('init')

" auto-pairs
packadd auto-pairs
let g:AutoPairsFlyMode = 0
