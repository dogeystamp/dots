-- Snippet engine

vim.cmd.packadd("LuaSnip")

local ls = require("luasnip")

-- see coding.lua because it also uses luasnip
-- snippets live in .config/nvim/snippets/

local confutil = require("confutil")
local keymap = confutil.keymap

--------------------------------
-- key bindings
--------------------------------

keymap("<Tab>", function()
	if ls.expandable() then
		ls.expand()
	elseif ls.locally_jumpable(1) and ls.in_snippet() then
		ls.jump(1)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
	end
end, { mode = { "i", "s" } })
keymap("<S-Tab>", function()
	ls.jump(-1)
end, { mode = { "s", "i" } })
keymap("<C-1>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { mode = { "s", "i" } })

--------------------------------
-- snippets
--------------------------------

require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
ls.config.setup({ enable_autosnippets = true })
