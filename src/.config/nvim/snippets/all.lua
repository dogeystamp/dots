return {
	s({ trig = "today", desc = "YYYY-MM-DD date of today" }, f(function ()
		return os.date("%Y-%m-%d")
	end))
}
