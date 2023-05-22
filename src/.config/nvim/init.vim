set tabstop=4 shiftwidth=4 noexpandtab ai nosmd ignorecase smartcase

" terminal settings
" disable line numbers
au TermOpen * setlocal nonumber norelativenumber
" make ESC go to normal mode
tnoremap <silent> <esc> <c-\><c-n><c-\><c-n>

" sign column on top of the line number (gutter for things like breakpoints, warnings)
set scl=number

" enable line numbers
set number relativenumber

" disable bottom right status line
set noruler
set showtabline=0

" performance?
set lazyredraw nocursorline ttyfast

" use system clipboard instead of internal
set clipboard=unnamedplus
" when using c or s, do not overwrite clipboard
nnoremap c "-c
nnoremap s "-s

let mapleader = ","

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

" copy URL under cursor to clipboard bind
:nnoremap <silent><leader>uu :let @+ = expand('<cfile>')<CR>

" Plugins

" Run PlugInstall if there are missing plugins
if $SYSTEM_PROFILE == "DEFAULT"
	autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	  \| PlugInstall --sync | source $MYVIMRC
	\| endif
endif

" The rest will not be sourced if the system is on minimal settings.
if $SYSTEM_PROFILE == "MINIMAL"
	finish
endif

call plug#begin()

filetype plugin indent on

" i don't use LaTeX anymore, but you can uncomment this to
"source $XDG_CONFIG_HOME/nvim/vimtex.vim

source $XDG_CONFIG_HOME/nvim/ultisnips.vim

if $SYSTEM_PROFILE == "DEFAULT"
	" notes and documents stuff
	source $XDG_CONFIG_HOME/nvim/typst.vim

	" plugins for IDE-like nvim
	source $XDG_CONFIG_HOME/nvim/coding.vim
endif

" URL motions
Plug 'axieax/urlview.nvim'

" fancy motions
Plug 'ggandor/leap.nvim'

Plug 'ledger/vim-ledger'

call plug#end()

if $SYSTEM_PROFILE == "DEFAULT"
	" see .config/nvim/lua/init.lua
	lua require('init')
endif
