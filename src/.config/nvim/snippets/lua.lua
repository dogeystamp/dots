return {
	s({ trig = "snip", desc = "meta snippet (snippet for making snippets)" }, fmt([[
	s({{trig="{}", desc="{}"}}, {}),
	]], { i(1, "trigger"), i(2, "human-readable description"), i(3, "<body nodes>") }))
}
