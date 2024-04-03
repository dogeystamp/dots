-- Snippet engine

-- see coding.lua because it also uses luasnip
-- snippets live in .config/nvim/snippets/

local confutil = require("confutil")
local keymap = confutil.keymap

--------------------------------
-- key bindings
--------------------------------

-- could not manage to replicate this behaviour in lua
-- if you nvim_feedkeys to pass through the <Tab> it infinite-loops
-- and also expr seems broken on my keymap() func
vim.cmd([[
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
]])

keymap("<Tab>", "<Plug>luasnip-jump-next", { mode = { "s" } })
keymap("<S-Tab>", "<Plug>luasnip-jump-prev", { mode = { "s", "i" } })
keymap("<C-e>", "<Plug>luasnip-next-choice", { mode = { "s", "i" } })

--------------------------------
-- snippets
--------------------------------

require("luasnip.loaders.from_lua").load({paths = vim.env.XDG_CONFIG_HOME .. "/nvim/snippets"})
