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

-- all of these binds are very helix-y
keymap("<localleader>/", scope.fzf_search)
keymap("<localleader>?", scope.rg_search)
keymap("<localleader>f", scope.file_finder)
keymap("<localleader>m", scope.buffer_list)
keymap("<localleader>s", vim.lsp.buf.workspace_symbol)

-- switch to last file
keymap("ga", "<c-^>")

--------------------------------
--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------
--------------------------------

require("frontend")
require("snippets")

if dotprofile >= profile_table.DEFAULT then
	require("coding")
	require("debugging")
end
