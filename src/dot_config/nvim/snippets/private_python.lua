return {
	s({ trig = "dbg", desc = "debug print" },
		fmt('print(f"DEBUG: {{{} = }}")',
			{ i(1, "expr") })),
}
