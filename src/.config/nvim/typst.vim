" typst filetype support
Plug 'kaarmu/typst.vim'

" edit figure in Inkscape
function EditFig()
	let figure_fname = expand('<cfile>')
	exec "silent !typst-figure " .. figure_fname
	vsp
	exec "term inkscape-shortcut-manager"
	quit
endfunc

nnoremap <silent><leader>ff :call EditFig()<cr>

" compile typst doc on write
function TypstWatch()
	vsp
	vertical resize 50
	exec 'terminal ' .. 'typst watch ' .. expand("%:t")
	exec "norm \<c-w>h"
endfunc
nnoremap <silent><leader>fc :call TypstWatch()<cr>
