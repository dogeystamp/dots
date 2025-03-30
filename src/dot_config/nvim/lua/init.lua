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

-- disable modelines (vim headers) in files
vim.o.modeline = false
-- manually trigger modeline
keymap("<leader>ml", function()
	vim.o.modeline = true
	vim.cmd.doautocmd("BufRead")
end)

--------
-- generic brand fuzzy finder
--------
local scope = require("scope")
scope.setup()

keymap("<leader>eg", scope.fzf_search)
keymap("<leader>eG", scope.rg_search)
keymap("<leader>ef", scope.file_finder)
keymap("<leader>em", scope.buffer_list)
keymap("<leader>es", vim.lsp.buf.workspace_symbol)

--------
-- auto-pairs for brackets
--------
vim.cmd.packadd("auto-pairs")

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
