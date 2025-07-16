-- snippets for ~/.local/bin/quickcal.fish

return {
	s({ trig = "sched", desc = "High-school style schedule" }, fmt([[
	08:45 09:30 {}
	09:30 10:15 {}
	10:30 12:00 {}
	13:00 14:30 {}
	14:45 15:45 {}
	]], { i(1), i(2), i(3), i(4), i(5) })),
}
