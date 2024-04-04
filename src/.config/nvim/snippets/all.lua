--------------------------------
--------------------------------
-- utility functions
--------------------------------
--------------------------------

-- if nil or empty, use placeholder
local function get_str(str, placeholder)
	if not str or str == "" then
		return placeholder
	else
		return str
	end
end

-- repeat i() node some amount of times
local function rep_node(args, snip)
	local ret = {}
	local line = string.rep(args[1][1], get_str(snip.captures[2], 16))
	for _ = 1, get_str(snip.captures[1], 1) do
		table.insert(ret, line)
	end
	return ret
end

-- see fbox snippet
local function box_line(args, snip, side)
	local shorthand = {
		r = "round",
		h = "heavy",
		s = "sharp",
	}
	local styles = {
		round = "╭─╮││╰─╯",
		heavy = "┏━┓┃┃┗━┛",
		sharp = "┌─┐││└─┘",
	}

	type = shorthand[snip.captures[1]] or "round"

	-- array of characters (because lua strings are not c-strings 😔)
	-- nor does nvim lua have utf-8 support 😔
	-- https://stackoverflow.com/a/27941567
	local style = {}
	for code in styles[type]:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		table.insert(style, code)
	end

	local content = (args[1] or { "" })[1]
	local content_len = string.len(content)

	if side == "left" then
		return style[4]
	elseif side == "right" then
		return style[5]
	end

	-- offset into the style
	local o = 1

	if side == "top" then o = 1 end
	if side == "bottom" then o = 6 end

	-- +2 for padding
	return style[o] .. string.rep(style[o + 1], content_len + 2) .. style[o + 2]
end

return {
	--------------------------------
	--------------------------------
	-- date and timekeeping snippets
	--------------------------------
	--------------------------------
	s({ trig = "today", desc = "YYYY-MM-DD date of today" }, f(function()
		return os.date("%Y-%m-%d")
	end)),

	s({ trig = "yesterday", desc = "YYYY-MM-DD date of yesterday" }, f(function()
		local t = os.date("*t")
		return os.date("%Y-%m-%d", os.time { year = t.year, month = t.month, day = t.day - 1 })
	end)),

	s({ trig = "timestamp", desc = "Unix day timestamp (locked to midnight)" }, f(function()
		local t = os.date("*t")
		return tostring(os.time { year = t.year, month = t.month, day = t.day, hour = 0 })
	end)),

	s(
		{
			trig = "datestamp (%d-)-(%d-)-(%d-)",
			regTrig = true,
			desc =
			"YYYY-MM-DD to Unix day timestamp (locked to midnight)"
		}, f(function(_, snip)
			return tostring(os.time { year = snip.captures[1], month = snip.captures[2], day = snip.captures[3], hour = 0 })
		end)),

	--------------------------------
	--------------------------------
	-- miscellaneous snippets
	--------------------------------
	--------------------------------
	s({ trig = "shrug", desc = "shrug emoticon (not escaped)" }, t("¯\\_(ツ)_/¯")),

	s(
		{
			trig = "(%d*)segm(%d-)",
			regTrig = true,
			desc = {
				"section/segment header title comment.", "",
				"number in front is height (default 1), second number is width.",
				"to use this, type the comment symbol (e.g. # or //) then TAB, then the section title.",
				"see also: https://www.pathsensitive.com/2023/12/should-you-split-that-file.html",
			}
		}, fmt([[
	{surr1}
	{comm} {cont}
	{surr2}
	]], {
			surr1 = f(rep_node, { 1 }),
			comm = d(1, function()
				local ft = vim.bo.filetype

				local ft_table = {
					c = "//",
					cpp = "//",
					rust = "//",
					lua = "--",
					python = "##",
				}

				local comm = ft_table[ft]
				if not comm then
					return sn(nil, { i(1) })
				end
				return sn(nil, { t(comm) })
			end),
			cont = i(2),
			surr2 = f(rep_node, { 1 })
		})),

	s(
		{ trig = "fbox(%a?)", regTrig = true, desc = { "draw a unicode box around some text.", "use fboxs for sharp corners (round default), fboxh for heavy" } },
		fmt([[
		{topline}
		{lside} {content} {rside}
		{bottomline}
		]], {
			content = i(1, "contents"),
			topline = f(box_line, { 1 }, { user_args = { "top" } }),
			bottomline = f(box_line, { 1 }, { user_args = { "bottom" } }),
			lside = f(box_line, { 1 }, { user_args = { "left" } }),
			rside = f(box_line, { 1 }, { user_args = { "right" } }),
		})),

	s({trig="trigger", desc="human-readable description"}, d(1, f(function (args)
		return "durr" .. args[1][1] .. "durr"
	end))),
}
