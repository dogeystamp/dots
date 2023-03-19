set tabstop=4 shiftwidth=4 noexpandtab relativenumber ai nu rnu nosmd ignorecase smartcase
set lazyredraw nocursorline ttyfast

let mapleader = ","

set shell=/bin/sh

hi Search cterm=NONE ctermfg=white ctermbg=blue
hi StatusLine ctermbg=NONE cterm=italic

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

tnoremap <silent> <esc> <c-\><c-n><c-\><c-n>
" start debugger
nnoremap <silent> <leader>dd :execute "Termdebug" $HOME .. "/.cache/termdebug/" .. expand("%:r")<cr>:Source<cr>
" compile
nnoremap <silent> <leader>dc :Source<cr>:w<cr>:execute "make ~/.cache/termdebug/" .. expand("%:r") .. " -f ~/.config/nvim/makefile"<cr>
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
" force exit (akin to ZZ, ZQ)
nnoremap ZF :qa!<cr>

" Plugins

" Run PlugInstall if there are missing plugins
" (disabled because it's kind of intense for weak devices)
"autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  "\| PlugInstall --sync | source $MYVIMRC
"\| endif


call plug#begin()

filetype plugin indent on

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


if has('python3')
	Plug 'SirVer/ultisnips'
	let g:UltiSnipsExpandTrigger="<c-m>"
	let g:UltiSnipsJumpForwardTrigger="<c-m>"
	let g:UltiSnipsJumpBackwardTrigger="<c-b>"
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips/']
endif

Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "javascript", "python", "vim", "latex", "fish", "bash" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,

    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
  },
}
EOF

" Code folding
"set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
"autocmd BufEnter * normal zR
