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
}
