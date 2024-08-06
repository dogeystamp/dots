" plug: typst.vim

" edit figure in Inkscape
function EditFig()
	" expands filename under cursor
	let figure_fname = expand('<cfile>')
	exec "silent !typst-figure " .. figure_fname
	vsp
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

nnoremap <silent><leader>fr :silent exec "!zathura --fork " . expand("%:p:r") . ".pdf &"<cr>

let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '$':'$', "```" : "```", "`": "`"}
