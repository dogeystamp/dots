-- lua entry point

-- this config is for NVIM v0.12.
-- notes:
-- *  LSP is enabled manually (for security reasons); use the ':lsp enable' command.
-- *  tree-sitter parsers are installed externally (e.g. via pacman)

local confutil = require("confutil")
local keymap = confutil.keymap
local dotprofile, profile_table, add_lazy = confutil.dotprofile, confutil.profile_table, confutil.add_lazy


------------------------
-- plugin installation
------------------------
require("plugins")
-- headless setup mode
if confutil.setup_mode then
    vim.pack.update(nil, { force = true })
    vim.cmd.quitall()
end


--------------------------------
-- general plugin configs
--------------------------------

-- make all window borders rounded
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
-- disable modelines (vim settings headers) in files
vim.o.modeline = false
-- manually trigger modeline
keymap("<leader>ml", function()
    vim.o.modeline = true
    vim.cmd.doautocmd("BufRead")
end)

-- helix-y binds
-- see: https://docs.helix-editor.com/keymap.html
keymap("ga", function()
    vim.cmd [[:b#]] -- alternate between files
end)

-- fzf.vim
-- see ':h fzf-vim' after plugin installation
vim.cmd.packadd("fzf.vim")
keymap("<localleader>f", vim.cmd.GFiles, { desc = "Picker: Git files" })
keymap("<localleader>F", vim.cmd.Files)
keymap("<localleader>b", vim.cmd.Buffers)
keymap("<localleader>j", vim.cmd.Jumps)
keymap("<localleader>g", ":GFiles?<Enter>")
keymap("<localleader>h", vim.cmd.History) -- notably different from Helix bind here
keymap("<localleader>/", vim.cmd.RG)
keymap("<localleader>?", vim.cmd.Lines)

-- see ftplugin/ledger.vim
vim.cmd.packadd("vim-ledger")

--------
-- code folding
--
-- useful binds include zM (close all folds), zA (recursively toggle fold), and zR (open all folds).
-- see :h usr_28 for more information about folds.
--------
vim.o.foldenable = false
vim.o.foldmethod = "expr"
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldcolumn = '0'
vim.o.foldtext = ""
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]


--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------

-- snippets
add_lazy(function()
    require("snippets")
end, {})

if dotprofile >= profile_table.DEFAULT then
    require("coding")
    local scope = require("scope")
    scope.setup()
end
