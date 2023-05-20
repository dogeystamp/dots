let g:vimspector_sidebar_width = 30
let g:vimspector_terminal_maxwidth = 30

func VimspectorTerminalSetup()
endfunc
au User VimspectorTerminalOpened call VimspectorTerminalSetup()
func VimspectorUISetup()
	"call win_gotoid(g:vimspector_session_windows.stack_trace)
endfunc
au User VimspectorUICreated call VimspectorUISetup()

" compile
function Compile()
	if exists("g:vimspector_session_windows.code")
		call win_gotoid(g:vimspector_session_windows.code)
	endif
	w
	execute "make ~/.cache/termdebug/bin/" .. expand("%:r") .. " -f ~/.config/nvim/makefile"
endfunction
nnoremap <silent> <leader>dc :call Compile()<cr>

" quickfix window (after running make)
nnoremap <silent> <leader>dqf :tab cope<cr>
nnoremap <silent> <leader>df :tabNext<cr>

nnoremap <silent> <leader>dd :call vimspector#Launch()<cr>
nnoremap <silent> <leader>de :call vimspector#Reset()<cr>

" write clipboard into input file
function WriteInput()
	let inputfile=$HOME .. "/.cache/termdebug/input/" .. expand("%:r")
	echo "Written input to '" .. inputfile .. "'."
	call writefile(getreg('+', 1, 1), inputfile)
endfunction
nnoremap <silent> <leader>rw :call WriteInput()<cr>

" feed from input file into program stdin
function RunInput()
	let l:winid = win_getid()
	call win_gotoid(g:vimspector_session_windows.code)
	let l:inputfile=$HOME .. "/.cache/termdebug/input/" .. expand("%:r")
	let @x = join(readfile(l:inputfile), "\n") .. "\n\n"
	call win_gotoid(g:vimspector_session_windows.terminal)
	normal G"xp
	call win_gotoid(l:winid)
endfunction
nnoremap <silent> <leader>ri :call RunInput()<cr>

" debugging program flow
nnoremap <silent> <leader>rs :call vimspector#Restart()<cr>
nnoremap <silent> <leader>rr :call vimspector#Stop()<cr>
nnoremap <silent> <leader>rf :call vimspector#Continue()<cr>
" codelldb breaks if you just restart directly
func VimspectorHardRestart()
	call vimspector#Stop()
	sleep 100m
	call vimspector#Restart()
endfunc
nnoremap <silent> <leader>rt :call VimspectorHardRestart()<cr>

nnoremap <silent> <c-p> :call vimspector#StepInto()<cr>
nnoremap <silent> <c-n> :call vimspector#StepOver()<cr>

" breakpoints
nnoremap <silent> <leader>dsf :call vimspector#ToggleBreakpoint()<cr>
nnoremap <silent> <leader>dsc :call vimspector#ClearBreakpoints()<cr>

" watches
au BufEnter vimspector.Watches* nnoremap <silent> <buffer> dd :call vimspector#DeleteWatch()<cr>

func VimspectorEval()
	let l:winid = win_getid()
	normal gv"xy
	call win_gotoid(g:vimspector_session_windows.output)
	execute "normal! ip " . @x . "\n\<Esc>"
	call win_gotoid(l:winid)
endfunc
vnoremap <silent> K :call VimspectorEval()<cr>
