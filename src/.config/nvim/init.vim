set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd ignorecase smartcase
set showtabline=0
set lazyredraw nocursorline ttyfast
set clipboard=unnamedplus

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
let g:termdebug_wide = 50

" Enter insert mode automatically in terminal windows
"au BufEnter term://* startinsert

au BufEnter *.c,*.cpp,*.h,*.hpp packadd termdebug
au TermOpen * setlocal nonumber norelativenumber

tnoremap <silent> <esc> <c-\><c-n><c-\><c-n>
" start debugger
nnoremap <silent> <leader>dd :execute "Termdebug" $HOME .. "/.cache/termdebug/" .. expand("%:r")<cr>:Source<cr>

" compile
function Compile()
	if exists(":Source")
		Source
	endif
	w
	execute "make ~/.cache/termdebug/" .. expand("%:r") .. " -f ~/.config/nvim/makefile"
endfunction
nnoremap <silent> <leader>dc :call Compile()<cr>

" write clipboard into input file
function WriteInput()
	let inputfile=$HOME .. "/.cache/termdebug/input/" .. expand("%:r")
	echo "Written input to '" .. inputfile .. "'."
	call writefile(getreg('+', 1, 1), inputfile)
endfunction
nnoremap <silent> <leader>rw :call WriteInput()<cr>

" start from input file
function RunInput()
	Stop
	Run
	Source
	let inputfile=$HOME .. "/.cache/termdebug/input/" .. expand("%:r")
	let @x = join(readfile(inputfile), "\n") .. "\n\n"
	Program
	normal G"xp
endfunction
nnoremap <silent> <leader>ri :call RunInput()<cr>

" start, stop, continue forwards
nnoremap <silent> <leader>rs :Run<cr>
nnoremap <silent> <leader>rr :Stop<cr>
nnoremap <silent> <leader>rf :Continue<cr>
" clear, add breakpoints
nnoremap <silent> <leader>dsc :Clear<cr>
nnoremap <silent> <leader>dsf :Break<cr>

nnoremap <silent> <C-h> :vertical resize -5<cr>
nnoremap <silent> <C-l> :vertical resize +5<cr>
nnoremap <silent> <c-p> :Step<cr>
nnoremap <silent> <c-n> :Over<cr>

" quickfix window (after running make)
nnoremap <silent> <leader>dqf :tab cope<cr>
nnoremap <silent> <leader>df :tabNext<cr>

vnoremap <silent> K :'<,'>Evaluate<cr>

" tab, window management
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
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

if $SYSTEM_PROFILE == "DEFAULT"
	Plug 'lervag/vimtex'
	let g:vimtex_view_method = 'zathura'
	let g:vimtex_compiler_method = 'latexmk'
	set conceallevel=0
	let g:tex_conceal='abdmg'
	let g:vimtex_view_forward_search_on_start=1
	let g:vimtex_compiler_latexmk = {
		\ 'build_dir' : $HOME.'/.cache/latexmk/',
		\ 'callback' : 1,
		\ 'continuous' : 1,
		\ 'executable' : 'latexmk',
		\ 'hooks' : [],
		\ 'options' : [
		\   '-verbose',
		\   '-file-line-error',
		\   '-synctex=1',
		\   '-interaction=nonstopmode',
		\ ],
		\}

	" spellcheck
	au BufEnter *.tex set spell spelllang=en_ca

	" Autowrite in tex files
	" au TextChanged,TextChangedI *.tex silent write
endif


if has('python3') && ($SYSTEM_PROFILE == "DEFAULT" || $SYSTEM_PROFILE == "SLIM")
	Plug 'SirVer/ultisnips'
	let g:UltiSnipsExpandTrigger="<c-m>"
	let g:UltiSnipsJumpForwardTrigger="<c-m>"
	let g:UltiSnipsJumpBackwardTrigger="<c-b>"
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips/']
endif

if $SYSTEM_PROFILE == "DEFAULT"
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/lsp-status.nvim'

	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'

	Plug 'stevearc/dressing.nvim'

	Plug 'nvim-treesitter/nvim-treesitter'
	" Code folding
	set foldmethod=expr
	set foldexpr=nvim_treesitter#foldexpr()
	"autocmd BufEnter * normal zR
endif

Plug 'axieax/urlview.nvim'

Plug 'ggandor/leap.nvim'

Plug 'kaarmu/typst.vim'

call plug#end()

if $SYSTEM_PROFILE == "DEFAULT"
	" see .config/nvim/lua/init.lua
	lua require('init')
endif
