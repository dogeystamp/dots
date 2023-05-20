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
