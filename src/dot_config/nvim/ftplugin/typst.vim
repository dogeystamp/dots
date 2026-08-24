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

" imports latest screenshot (from clipboard) into a figure
function ScreenshotFig()
	call system("mkdir -p " . expand("<cfile>:h") . ";"
		\ . "TEMP=$(mktemp --suffix=.png)" . ";"
		\ . 'cb > "$TEMP"' . ";"
		\ . 'ffmpeg -y -i $TEMP "'.expand("<cfile>").'";'
		\ . 'rm "$TEMP"' . ";"
	\ )
endf
nnoremap <silent><leader>fs :call ScreenshotFig()<cr>

function GitRoot()
	return fnamemodify(finddir('.git', ";"), ":h")
endfunc

" compile typst doc on write.
"
" use the gt/gT (go to next/prev tab) binds to switch to/from the compile
" output buffer.
function TypstWatch()
    let file_path = GitRoot() .. " " .. expand("%:")
    tabnew
    exec 'terminal ' .. 'typst watch --root ' .. file_path
    tabprev
endfunc

function OpenZathura()
    silent exec "!zathura --fork " . expand("%:p:r") . ".pdf &"
endfunc

nnoremap <silent> <leader>fc :call TypstWatch()<cr>:call OpenZathura()<cr>
nnoremap <silent><leader>fr :call OpenZathura()<cr>

let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '$':'$', "```" : "```", "`": "`"}
