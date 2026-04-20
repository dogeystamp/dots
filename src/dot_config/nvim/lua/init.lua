-- lua entry point

-- this config is for NVIM v0.12.
-- notes:
-- *  LSP is enabled manually (for security reasons); use the ':lsp enable' command.
-- *  tree-sitter parsers are installed externally (e.g. via pacman)

local confutil = require("confutil")
local keymap = confutil.keymap
local dotprofile, profile_table = confutil.dotprofile, confutil.profile_table

-------------------------
-- plugin installation
-- (requires nvim v0.12)
--
-- blink.cmp is optional (because it's heavy) and added in coding.lua
-------------------------

vim.pack.add({
    { src = "https://github.com/ledger/vim-ledger.git",          version = "46b4b1158a6304285cab8917a4cd89f641ad8f0f" },
    { src = "https://github.com/L3MON4D3/LuaSnip",               version = "642b0c595e11608b4c18219e93b88d7637af27bc" },
    { src = "https://github.com/junegunn/fzf.vim",               version = "b9624aa012ddcbae9e79964bfd30cc1fbe3cf263" },
    { src = "https://github.com/altermo/ultimate-autopair.nvim", version = "6b58234de921437836efe27714b2026ed2ee235a" },
})

--------------------------------
-- general plugin configs
--------------------------------

-- make all window borders rounded
vim.o.winborder = "rounded"

-- disable modelines (vim headers) in files
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
keymap("<localleader>f", vim.cmd.GFiles, { desc = "Picker: Git files" })
keymap("<localleader>F", vim.cmd.Files)
keymap("<localleader>b", vim.cmd.Buffers)
keymap("<localleader>j", vim.cmd.Jumps)
keymap("<localleader>g", ":GFiles?<Enter>")
keymap("<localleader>h", vim.cmd.History) -- notably different from Helix bind here
keymap("<localleader>/", vim.cmd.RG)
keymap("<localleader>?", vim.cmd.Lines)

--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------

require("snippets")

if dotprofile >= profile_table.DEFAULT then
    require("coding")
    local scope = require("scope")
    scope.setup()
end
