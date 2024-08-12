return {
	s({
		trig = "snipf",
		desc = "meta snippet (snippet for making snippets)"
	}, fmt([[
	s({{
		trig="{}",
		name="{}",
		desc="{}",
	}},
		{}
	),
	]], { i(1, "trigger"), i(2, "human-readable name"), i(3, "human-readable description"), i(4, "body") }))
}
