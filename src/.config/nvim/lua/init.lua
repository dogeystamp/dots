-- lua entry point

local confutil = require("confutil")

local keymap = confutil.keymap
local dotprofile, profile_table = confutil.dotprofile, confutil.profile_table

--------------------------------
--------------------------------
-- miscellaneous plugins
--------------------------------
--------------------------------

-- bind to copy URL under cursor
keymap("<leader>uu", ":let @+ = expand('<cfile>')<cr>")

------
-- fancy prompts
-- plug: dressing.nvim, telescope.nvim, plenary.nvim
------
require('dressing').setup({
	input = {
		insert_only = false,
	}
})
keymap("<leader>ef", "<cmd>Telescope find_files<cr>")
keymap("<leader>eg", "<cmd>Telescope live_grep<cr>")
keymap("<leader>em", "<cmd>Telescope buffers<cr>")
keymap("<leader>eh", "<cmd>Telescope help_tags<cr>")
keymap("<leader>es", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
keymap("<leader>eb", "<cmd>Telescope keymaps<cr>")

--------------------------------
--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------
--------------------------------

require("theme")
require("snippets")

if dotprofile >= profile_table.DEFAULT then
	require("coding")
	require("debugging")
end
