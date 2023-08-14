" snippet engine (see .config/nvim/ultisnips/)

if has('python3') && ($SYSTEM_PROFILE == "DEFAULT" || $SYSTEM_PROFILE == "SLIM")
	Plug 'SirVer/ultisnips'
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpForwardTrigger="<tab>"
	let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips/']
endif
