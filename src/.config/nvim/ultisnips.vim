" snippet engine (see .config/nvim/ultisnips/)

if has('python3') && ($SYSTEM_PROFILE == "DEFAULT" || $SYSTEM_PROFILE == "SLIM")
	Plug 'SirVer/ultisnips'
	let g:UltiSnipsExpandTrigger="<c-m>"
	let g:UltiSnipsJumpForwardTrigger="<c-m>"
	let g:UltiSnipsJumpBackwardTrigger="<c-b>"
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips/']
endif
