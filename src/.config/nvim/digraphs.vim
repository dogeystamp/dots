" see :help digraphs
" these digraphs are reminiscent of canadian french keyboard layout
call digraph_setlist([
		\["'a", 'à'],
		\["'e", 'è'],
		\["'u", 'ù'],
		\["/e", 'é'],
		\["}a", 'ä'],
		\["}e", 'ë'],
		\["}i", 'ï'],
		\["}o", 'ö'],
		\["}u", 'ü'],
		\["}y", 'ÿ'],
		\["]c", 'ç'],
		\["[a", 'â'],
		\["[e", 'ê'],
		\["[i", 'î'],
		\["[o", 'ô'],
		\["[u", 'û'],
	\])

" misc funny digraphs
call digraph_setlist([
		\["++", '✝'],
		\["+-", '†'],
	\])
