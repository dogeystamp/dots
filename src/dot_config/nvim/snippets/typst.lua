return {
	--------------------------------
	--------------------------------
	-- quick markup utilities
	--------------------------------
	--------------------------------

	s({ trig = "ss", name = "superscript", wordTrig = false }, fmt("^({})", { i(1) })),
	s({ trig = "qu", name = "square (qu-artic) exponent", wordTrig = false }, t("^2")),
	s({ trig = "cub", name = "cub-ed exponent", wordTrig = false }, t("^3")),

	-- limits
	s({ trig = "plus", name = "plus exponent", wordTrig = false }, t("^+")),
	s({ trig = "min", name = "minus exponent", wordTrig = false }, t("^-")),
	s({ trig = "lim", name = "limit", wordTrig = true }, fmt("lim_({}) ", { i(1) })),
	s({ trig = "inf", name = "infinity", wordTrig = true }, t("infinity")),

	-- derivative
	s({ trig = "dx", name = "difference x", wordTrig = true }, t("/(dif x)")),
	s({ trig = "dy", name = "difference y", wordTrig = true }, t("(dif y)")),
	s({ trig = "der", name = "derivative", wordTrig = true }, t("dif/(dif x)")),

	s({
			trig = "numb",
			name = "numbered equation",
			wordTrig = false
		},
		fmt(
			"#numbered_eq()[${}$ <{}>]",
			{
				i(1, "equation"),
				i(2, "label")
			})),

	s({ trig = "link", desc = "labelled link" }, fmt('#link("{}{}")[{}]', {
		i(1),
		f(function(args, _)
			-- use clipboard contents as a placeholder
			if not args[1][1] or args[1][1] == "" then
				return vim.fn.getreg("+")
			else
				return ""
			end
		end, { 1 }),
		i(2),
	})),

	s({
			trig = "qty",
			name = "quantity + unit",
			wordTrig = false
		},
		fmt(
			[[#qty("{}", "{}")]],
			{
				i(1, "numb"),
				i(2, "unit")
			})),

	s({
			trig = "pq",
			name = "percentage error quantity",
			wordTrig = false
		},
		fmt(
			[[#pq("{}", "{}", "{}")]],
			{
				i(1, "numb"),
				i(2, "unit"),
				i(3, "percentage error"),
			})),

	--------------------------------
	--------------------------------
	-- figures
	-- (biggest waste of time ever)
	-- (supposedly advanced snippet practice)
	--------------------------------
	--------------------------------
	s({ trig = "fig(%a?)", regTrig = true, desc = "create a figure" }, fmt([[
	#figure(
	  {content}
	  caption: [{caption}],
	) <{label}>
	]], {
		caption = i(2, "Caption"),
		label = i(1, "label"),
		content = d(3, function(args, snip)
			if not snip.captures[1] or snip.captures[1] == "" then
				-- regular figure
				return sn(nil,
					fmt([[
					image("{path}.{ext}"),
					]], {
						path = f(function()
							return "fig/" .. vim.fn.expand("%:r") .. "/" .. (args[1][1] or nil)
						end),
						ext = c(1, { t("svg"), t("jpg") })
					})
				)
			elseif snip.captures[1] == "t" then
				return sn(nil,
					fmt([[
					tablef(
					    columns: {cols},
					    table.header{head},
					    {content}
					  ),
					]], {
						head = i(1, "[Header][Header]"),
						content = i(2, "[Content], [Content],"),
						cols = f(function(largs)
							-- the number of columns is the number of left brackets [ in the header
							local _, cnt = string.gsub(largs[1][1], "%[", "")
							-- the error for not converting to string was cryptic
							-- wasted 10 minutes on this :(
							return tostring(cnt)
						end, { 1 })
					})
				)
			end
		end, { 1 }),
	})),

	--------------------------------
	--------------------------------
	-- document templates
	--------------------------------
	--------------------------------
	s({ trig = "general", desc = "General document template" }, fmt([[
	#import "/templates/general.typ": template, lref
	#import "/templates/libs.typ": *
	#show: template.with(
	  title: "{}",
	  prefix: "{}",
	  suffix: "{}",
	)
	]], { i(1), i(2), i(3) })),

	s({ trig = "problem", desc = "Problem write-up template" }, fmt([[
	#import "/templates/problems.typ": template, source_code, status, lref
	#import "/templates/libs.typ": *
	#show: template.with(
	  problem_url: "{}",
	  title: "{}",
	  stat: "{}",
	)
	]], { i(1), i(2), t("incomplete") })),
}
