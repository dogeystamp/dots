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
}
