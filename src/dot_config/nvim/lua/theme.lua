------
-- color theme
------

vim.cmd.packadd("nvim-noirbuddy")
vim.cmd.packadd("colorbuddy.nvim")

require("noirbuddy").setup({
	colors = {
		primary = "#99AABB"
	},
	styles = {
		italic = true,
		bold = false,
		underline = true,
		undercurl = true,
	},
	preset = "slate",
})

local colorbuddy = require("colorbuddy")

-- force transparent bg

local colors = colorbuddy.colors
local Group = colorbuddy.Group
local groups = colorbuddy.groups
local styles = colorbuddy.styles

Group.new("Normal", colors.noir_4, colors.none, nil)
Group.new("StatusLine", colors.noir_4, colors.none, styles.bold)
Group.link("MsgArea", groups.Normal)
-- not selected statusline
Group.new("StatusLineNC", colors.noir_7, colors.none)
Group.link("Gutter", groups.normal)
Group.new("LineNr", colors.noir_8, colors.none, nil)
Group.link("SignColumn", groups.LineNr)
Group.new("VertSplit", colors.noir_9, colors.none, nil)

-- other overrides
Group.new("CurSearch", colors.noir_9, colors.primary)

Group.new("identifier", colors.noir_3, nil, nil)

Group.new("function", colors.noir_2, nil)
Group.link("@function", groups["function"])
Group.link("String", groups["@string"])
Group.link("@lsp.type.function", groups["function"])

Group.new("comment", colors.noir_6, nil, styles.italic)
Group.link("@comment", groups.comment)

Group.new("keyword.return", colors.noir_4, nil, styles.bold)
Group.link("@keyword.return", groups["keyword.return"])
Group.link("type.qualifier", groups["keyword.return"])
Group.link("@type.qualifier", groups["keyword.return"])

Group.new("NormalFloat", colors.noir_1, colors.noir_9, nil)

Group.new("NonText", colors.noir_9, nil, nil)

-- swap undercurls and underlines
for _, v in ipairs({ "Error", "Info", "Hint", "Warn" }) do
	local col_name = "diagnostic_" .. string.lower(v)
	if v == "Warn" then
		col_name = "diagnostic_warning"
	end

	Group.new("Diagnostic" .. v, colors[col_name], nil, styles.underline)
	Group.new("DiagnosticUnderline" .. v, colors[col_name], nil, styles.undercurl)
end

-- DAP-ui colors

Group.new("debugPC", colors.primary, colors.noir_8)
Group.new("DapUIModifiedValue", colors.primary, nil, styles.bold)
Group.new("DapUIWatchesEmpty", colors.noir_8, nil, nil)
Group.new("DapUIWatchesError", colors.diff_delete, nil, nil)
Group.new("DapUISource", colors.primary, nil, nil)
Group.new("DapUILineNumber", colors.noir_5, nil, nil)
Group.new("DapUIScope", colors.noir_5, nil, nil)
Group.new("DapUIDecoration", colors.secondary, nil, nil)
Group.new("DapUIStoppedThread", colors.primary, nil, nil)
Group.new("DapUIBreakpointsCurrentLine", colors.primary, nil, nil)
Group.link("DapUIType", groups["@type.builtin"])
Group.link("DapUIVariable", groups["@variable"])
Group.link("DapUIValue", groups["@number"])
Group.link("DapUIFloatBorder", groups.FloatBorder)
