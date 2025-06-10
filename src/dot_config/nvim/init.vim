set tabstop=4 shiftwidth=4 noexpandtab smartindent
set ignorecase smartcase

" Disable mode indicator
set noshowmode

" Persist undos
set undofile

" visible whitespace
set list listchars=tab:»\ ,trail:•,leadmultispace:\│\ \ \ ,extends:⇥,precedes:⇤

" Time neovim saves to swapfile in
" Also time neovim recognizes cursor inactivity
set updatetime=800

" terminal settings
" disable line numbers
au TermOpen * setlocal nonumber norelativenumber
" escape
tnoremap <Esc> <c-\><c-n><c-\><c-n>

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

" disable command line when not in use
set cmdheight=0

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
nmap <C-S>Y "+Y
nmap <C-S>D "+D
vmap <C-S>y "+y
nmap <C-S>d "+d
vmap <C-S>d "+d
nmap <C-S>c "+c
nmap <C-S>C "+C
vmap <C-S>c "+c
nmap <C-S>p "+p

" delete (do not save to register) bind
vnoremap X "_d
nnoremap X "_d
nnoremap XX "_dd

" faster indent binds
" conflicts with motions, e.g. <ip
nnoremap > >>
nnoremap < <<
" don't deselect after a visual indent
vnoremap < <gv
vnoremap > >gv

" 0 is easier to reach so swap these binds
nnoremap 0 ^
nnoremap ^ 0
vnoremap 0 ^
vnoremap ^ 0
snoremap 0 0

" steal the emacs end-of-line bind (easier to type than <Esc>A)
inoremap <C-e> <C-o>A
snoremap <C-e> <C-o>A

set shell=/bin/sh

autocmd InsertEnter * hi StatusLine cterm=bold
autocmd InsertLeave * hi StatusLine cterm=italic

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

" disable warnings in health check
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

source $XDG_CONFIG_HOME/nvim/theme.vim
