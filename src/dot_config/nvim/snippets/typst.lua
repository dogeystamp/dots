local MATH_NODES = {
	formula = true,
	math = true,
}

local NON_MATH_NODES = {
	code = true,
	text = true,
	raw_blck = true,
	source_file = true,
}

local function is_math_mode()
	local node = vim.treesitter.get_node({ ignore_injections = false })
	while node do
		print(node:type())
		if NON_MATH_NODES[node:type()] then
			return false
		elseif MATH_NODES[node:type()] then
			return true
		end
		node = node:parent()
	end
	return true
end

return {
	--------------------------------
	--------------------------------
	-- quick markup utilities
	--------------------------------
	--------------------------------

	-- if you don't want to trigger some of these automatic snippets,
	-- for example to type a literaly 'uq', type ctrl-v q and it will type
	-- a 'q' without triggering

	s(
		{
			-- this is python's exponentiation syntax
			trig = "**",
			name = "superscript",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, fmt("^({})", { i(1) })),

	-- note there is no subscript snippet because unlike the ^ key, _ is pretty easy to reach

	s(
		{
			-- this used to be qu, but you should avoid ending triggers with u
			-- because ctrl-v u is already a bind (:h i_CTRL-V_digit)
			trig = "uq",
			name = "s-uq-are exponent",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, t("^2")),
	s(
		{
			trig = "cub",
			name = "cub-ed exponent",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, t("^3")),
	s(
		{
			-- you need to type a space before to trigger this
			trig = " /",
			name = "fraction",
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, fmt("/({})", { i(1) })),
	s(
		{
			trig = "#",
			name = "code (inline math)",
			desc = "Tells tree-sitter that we are in a code block, to prevent completing math elements.",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, fmt("#({})", { i(1) })),

	-- limits
	s({ trig = "plus", name = "plus exponent", wordTrig = false }, t("^+")),
	s({ trig = "min", name = "minus exponent", wordTrig = false }, t("^-")),
	s({ trig = "lim", name = "limit", wordTrig = true }, fmt("lim_({}) ", { i(1) })),
	s({ trig = "integral", name = "integral (definite)", wordTrig = true }, fmt("integral_({})^({}) ", { i(1), i(2) })),
	s({ trig = "sum", name = "summation", wordTrig = true }, fmt("sum_({})^({}) ", { i(1), i(2) })),
	s({ trig = "inf", name = "infinity", wordTrig = true }, t("infinity")),
	s({ trig = "abs", name = "absolute value", wordTrig = true }, fmt("abs({})", { i(1) })),

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
						ext = c(1, { t("svg"), t("jpg"), t("png") })
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

	-- this template is deprecated
	s({ trig = "general", desc = "General document template" }, fmt([[
	#import "/templates/general.typ": template, lref
	#import "/templates/libs.typ": *
	#show: template.with(
	  title: "{}",
	  prefix: "{}",
	  suffix: "{}",
	)

	]], { i(1), i(2), i(3) })),

	-- this template is deprecated
	s({ trig = "problem", desc = "Problem write-up template" }, fmt([[
	#import "/templates/problems.typ": template, source_code, status, lref
	#import "/templates/libs.typ": *
	#show: template.with(
	  problem_url: "{}",
	  title: "{}",
	  stat: "{}",
	)

	]], { i(1), i(2), t("incomplete") })),

	s({ trig = "book", desc = "New notes template" }, fmt([[
	#import "@local/mousse-notes:0.1.0": *
	#set page(paper: "us-letter")
	#show: book.with(
	  title: [{}],
	  subtitle: {},
	  subsubtitle: {},
	  subsubsubtitle: {},
	  author: {},
	)


	]], { i(1), i(2, "none"), i(3, "none"), i(4, "none"), i(5, "none") })),
}
