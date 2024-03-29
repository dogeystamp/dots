-- lua entry point

confutil = require("confutil")

keymap = confutil.keymap
dotprofile, profile_table = confutil.dotprofile, confutil.profile_table

--------------------------------
--------------------------------
-- miscellaneous plugins
--------------------------------
--------------------------------

------
-- url motions
-- plug: urlview.nvim
------
require("urlview").setup({
	jump = {
		prev = "<leader>uj",
		next = "<leader>uh",
	},
})
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
keymap("<leader>es", "<cmd>Telescope lsp_document_symbols<cr>")
keymap("<leader>eb", "<cmd>Telescope keymaps<cr>")

------
-- color theme
-- plug: nvim-noirbuddy, colorbuddy.nvim
------
require("noirbuddy").setup({
	colors = {
		primary="#99AABB"
	},
	styles = {
		italic = true,
		bold = false,
		underline = true,
		undercurl = true,
	},
	preset = "slate",
})
-- force transparent bg
local Color, colors, Group, groups, styles = require("colorbuddy").setup {}
Group.new("Normal", colors.noir_4, colors.none, no)
Group.link("StatusLine", groups.normal)
Group.link("Gutter", groups.normal)
Group.new("LineNr", colors.noir_8, colors.none, no)
Group.link("SignColumn", groups.LineNr)

-- other overrides
Group.new("identifier", colors.noir_3, nil, no)

Group.new("function", colors.noir_2, nil)
Group.link("@function", groups["function"])
Group.link("@lsp.type.function", groups["function"])

Group.new("comment", colors.noir_6, nil, styles.italic)
Group.link("@comment", groups.comment)

Group.new("keyword.return", colors.noir_4, nil, styles.bold)
Group.link("@keyword.return", groups["keyword.return"])
Group.link("type.qualifier", groups["keyword.return"])
Group.link("@type.qualifier", groups["keyword.return"])

Group.new("NormalFloat", colors.noir_1, colors.noir_9, no)

-- swap undercurls and underlines
for _, v in ipairs({"Error", "Info", "Hint", "Warn"}) do
	col_name = "diagnostic_" .. string.lower(v)
	if v == "Warn" then
		col_name = "diagnostic_warning"
	end

	Group.new("Diagnostic" .. v, colors[col_name], nil, styles.underline)
	Group.new("DiagnosticUnderline" .. v, colors[col_name], nil, styles.undercurl)
end

--------------------------------
--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------
--------------------------------

if dotprofile >= profile_table.DEFAULT then
	require("coding")
	require("debugging")
end
