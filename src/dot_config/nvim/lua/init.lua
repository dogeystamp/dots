-- lua entry point

-- this config is for NVIM v0.12.
-- notes:
-- *  LSP is enabled manually (for security reasons); use the ':lsp enable' command.
-- *  tree-sitter parsers are installed externally (e.g. via pacman)

local confutil = require("confutil")
local keymap = confutil.keymap
local dotprofile, profile_table, add_lazy = confutil.dotprofile, confutil.profile_table, confutil.add_lazy

-------------------------
-- plugin installation
-- (requires nvim v0.12)
--
-- note that other plugins are added in different files; grep for vim.pack.add
-------------------------

vim.pack.add({
    { src = "https://github.com/ledger/vim-ledger.git",          version = "46b4b1158a6304285cab8917a4cd89f641ad8f0f" },
    { src = "https://github.com/junegunn/fzf.vim",               version = "b9624aa012ddcbae9e79964bfd30cc1fbe3cf263" },
})

-- lazily loaded
vim.pack.add(
    {
        { src = "https://github.com/L3MON4D3/LuaSnip", version = "642b0c595e11608b4c18219e93b88d7637af27bc" },
        { src = "https://github.com/saghen/blink.cmp", version = "78336bc89ee5365633bcf754d93df01678b5c08f" },
        { src = "https://github.com/altermo/ultimate-autopair.nvim", version = "6b58234de921437836efe27714b2026ed2ee235a" },
    },
    { load = function() end }
)


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
