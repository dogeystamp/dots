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

-- https://stackoverflow.com/a/5761649
package.path = "../lua/?.lua;" .. package.path
local utf8_u = require("utf8-util")

--------------------------------
-- fbox snippet helper functions
--------------------------------

---format box sides
---@param style_code string?
---@param side string
---@param sz integer
---@param width integer?
---@return string
local function box_line(style_code, side, sz, width)
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

	type = shorthand[style_code] or "round"

	-- array of characters (because lua strings are not c-strings 😔)
	-- nor does nvim lua have utf-8 support 😔
	-- https://stackoverflow.com/a/27941567
	local style = {}
	for code in styles[type]:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		table.insert(style, code)
	end

	if side == "left" then
		return style[4]
	elseif side == "right" then
		return string.rep(" ", (width or sz) - sz) .. style[5]
	end

	-- offset into the style
	local o = 1

	if side == "top" then o = 1 end
	if side == "bottom" then o = 6 end

	-- +2 for padding
	return style[o] .. string.rep(style[o + 1], sz) .. style[o + 2]
end
local function box_fct(args, snip, side)
	local content = args[1] or { "" }
	local content_width = 0
	for _, line in ipairs(content) do
		content_width = math.max(content_width, utf8_u.mono_len(line))
		print(content_width)
	end
	return box_line(snip.captures[1], side, content_width - 2)
end

return {
	--------------------------------
	--------------------------------
	-- date and timekeeping snippets
	--------------------------------
	--------------------------------
	s({
		trig = "today",
		name = "Today date format",
		desc = "YYYY-MM-DD date of today"
	}, f(function()
		return os.date("%Y-%m-%d")
	end)),

	s({
		trig = "yesterday",
		name = "Yesterday date format",
		desc = "YYYY-MM-DD date of yesterday"
	}, f(function()
		local t = os.date("*t")
		return os.date("%Y-%m-%d", os.time { year = t.year, month = t.month, day = t.day - 1 })
	end)),

	s({
		trig = "tomorrow",
		name = "Tomorrow date format",
		desc = "YYYY-MM-DD date of tomorrow"
	}, f(function()
		local t = os.date("*t")
		return os.date("%Y-%m-%d", os.time { year = t.year, month = t.month, day = t.day + 1 })
	end)),

	s({
		trig = "timestamp",
		name = "Unix day timestamp",
		desc = "Unix time for today (locked to midnight)"
	}, f(function()
		local t = os.date("*t")
		return tostring(os.time { year = t.year, month = t.month, day = t.day, hour = 0 })
	end)),

	s(
		{
			trig = "datestamp (%d-)-(%d-)-(%d-)",
			name = "Unix timestamp based on date",
			regTrig = true,
			desc =
			"YYYY-MM-DD to Unix day timestamp conversion (locked to midnight)"
		}, f(function(_, snip)
			return tostring(os.time { year = snip.captures[1], month = snip.captures[2], day = snip.captures[3], hour = 0 })
		end)),

	--------------------------------
	--------------------------------
	-- miscellaneous snippets
	--------------------------------
	--------------------------------
	s({
		trig = "shrug",
		desc = "shrug emoticon (not escaped)"
	}, t("¯\\_(ツ)_/¯")),

	s(
		{
			trig = "(%d*)segm(%d-)",
			regTrig = true,
			name = "section/segment header title comment.",
			desc = {
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
					yaml = "##",
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
		{
			trig = "fbox(%a?)",
			regTrig = true,
			name = "format box",
			desc = { "draw a unicode box around some text.", "use fboxs for sharp corners (round default), fboxh for heavy" }
		},
		fmt([[
		{surr1}
		{content}
		{surr2}
		]],
			{
				content = i(1, "contents", {
					node_callbacks = {
						[events.leave] = function(node)
							local t = node:get_text()
							local width = 0
							for _, line in ipairs(t) do
								width = math.max(width, utf8_u.mono_len(line))
							end
							local new_t = {}
							for _, l in ipairs(t) do
								local sz = utf8_u.mono_len(l)
								local style_code = node.parent.captures[1]
								table.insert(new_t,
									box_line(style_code, "left", sz, width) ..
									" " .. l .. " " .. box_line(style_code, "right", sz, width))
							end
							node:set_text(new_t)
						end
					}
				}),
				surr1 = f(box_fct, { 1 }, { user_args = { "top" } }),
				surr2 = f(box_fct, { 1 }, { user_args = { "bottom" } }),
			})),
}
