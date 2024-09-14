-- lua entry point

vim.cmd.packadd("plenary.nvim")

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

-- requires plenary.nvim
vim.cmd.packadd("telescope.nvim")
keymap("<leader>eg", "<cmd>Telescope live_grep<cr>")
keymap("<leader>eh", "<cmd>Telescope help_tags<cr>")
keymap("<leader>eb", "<cmd>Telescope keymaps<cr>")

--------
-- generic brand fuzzy finder
--------
local scope = require("scope")
scope.setup()

keymap("<leader>ef", scope.file_finder)
keymap("<leader>em", scope.buffer_list)
keymap("<leader>es", vim.lsp.buf.workspace_symbol)


--------------------------------
--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------
--------------------------------

require("frontend")
require("theme")
require("snippets")

if dotprofile >= profile_table.DEFAULT then
	require("coding")
	require("debugging")
end
