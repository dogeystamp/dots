set tabstop=4 shiftwidth=4 expandtab
set ignorecase smartcase

" Enable custom window title
set title

" Disable mode indicator
set noshowmode

" Persist undos
set undofile

" visible whitespace
set list listchars=tab:»\ ,trail:•,leadmultispace:\│\ \ \ ,extends:⇥,precedes:⇤

" Time neovim saves to swapfile in
" Also time neovim recognizes cursor inactivity
set updatetime=100

" terminal settings
" disable line numbers
au TermOpen * setlocal nonumber norelativenumber
" escape
tnoremap <Esc> <c-\><c-n><c-\><c-n>

" Set sign column width
set signcolumn=auto:2

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
" set cmdheight=0

let mapleader = ","
let maplocalleader = " "

" easier binds to use system clipboard with
nnoremap + "+
vnoremap + "+

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
" helix-style window management
nnoremap <Space>w <C-w>

source $XDG_CONFIG_HOME/nvim/theme.vim

" see .config/nvim/lua/init.lua
lua require('init')

" disable warnings in health check
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" see .local/bin/quickcal.fish
autocmd BufNew,BufNewFile,BufRead *.khal setlocal ft=khal

