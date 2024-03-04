set tabstop=4 shiftwidth=4 noexpandtab ai nosmd ignorecase smartcase

" Time neovim saves to swapfile in
" Also time neovim recognizes cursor inactivity
set updatetime=800

" terminal settings
" disable line numbers
au TermOpen * setlocal nonumber norelativenumber
" make ESC go to normal mode
tnoremap <silent> <esc> <c-\><c-n><c-\><c-n>

" sign column on top of the line number (gutter for things like breakpoints, warnings)
" set scl=number

" enable line numbers
set number relativenumber

" disable bottom right status line
set noruler
set showtabline=0

" performance?
set lazyredraw nocursorline ttyfast

let mapleader = ","

" " use system clipboard instead of internal
" set clipboard=unnamedplus
" " when using c or s, do not overwrite clipboard
" nnoremap c "-c
" vnoremap c "-c
" nnoremap s "-s
" vnoremap s "-s

" easier binds to use system clipboard with
nmap <leader>y "+y
vmap <leader>y "+y
" <leader>d is for debugging
" and nobody uses clipboard c amirite or amirite
nmap <leader>c "+d
vmap <leader>c "+d

set shell=/bin/sh

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic
hi SignColumn ctermbg=NONE

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

highlight LineNr ctermfg=grey

" Disable highlighting when searching
nnoremap <silent> <esc> :noh<return><esc>

" shortcuts to type symbols easier
source $XDG_CONFIG_HOME/nvim/digraphs.vim

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

" The rest will not be sourced if the system is on minimal settings.
if $SYSTEM_PROFILE == "MINIMAL"
	finish
endif

filetype plugin indent on

source $XDG_CONFIG_HOME/nvim/ultisnips.vim

if $SYSTEM_PROFILE == "DEFAULT"
	" plugins for IDE-like nvim
	source $XDG_CONFIG_HOME/nvim/coding.vim
endif

" personal preference
autocmd ColorScheme * highlight clear statusline
set shortmess+=I

" gitgutter
" adds git diffs to the gutter (side bar thing)
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red

" fancy picker stuff

source $XDG_CONFIG_HOME/nvim/color.vim
