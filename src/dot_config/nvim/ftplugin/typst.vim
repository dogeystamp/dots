" plug: typst.vim

" edit figure in Inkscape
function EditFig()
	" expands filename under cursor
	let figure_fname = expand('<cfile>')
	exec "silent !typst-figure " .. figure_fname
	sp
	exec "term inkscape-shortcut-single"
	quit
endfunc

nnoremap <silent><leader>ff :call EditFig()<cr>

" imports latest screenshot into a figure
function ScreenshotFig()
	call system("mkdir -p " . expand("<cfile>:h"))
	call system("ffmpeg -y -i ~/med/screen/latest.png " . expand("<cfile>"))
endf
nnoremap <silent><leader>fs :call ScreenshotFig()<cr>

function GitRoot()
	return fnamemodify(finddir('.git', ";"), ":h")
endfunc

" compile typst doc on write
function TypstWatch()
       vsp
       vertical resize 20
       exec 'terminal ' .. 'typst watch --root ' .. GitRoot() .. " " .. expand("%:")
       exec "norm \<c-w>h"
endfunc

nnoremap <silent> <leader>fc :call TypstWatch()<cr>

nnoremap <silent><leader>fr :silent exec "!zathura --fork " . expand("%:p:r") . ".pdf &"<cr>

let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '$':'$', "```" : "```", "`": "`"}
