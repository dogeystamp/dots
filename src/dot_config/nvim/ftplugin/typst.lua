-- tinymist (typst lsp) configuration

local confutil = require("confutil")
local keymap = confutil.keymap

-- live preview command
keymap('<leader>fp',
	function()
		vim.lsp.get_clients({ name = "tinymist" })[1]:exec_cmd({ command = "tinymist.startDefaultPreview", title =
		"Preview" })
	end,
	{ noremap = true, silent = true })
