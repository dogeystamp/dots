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
    -- this is not currently working
	local node = vim.treesitter.get_node({ ignore_injections = false })
	while node do
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
			trig = "*2",
			name = "square exponent",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, t("^2")),
	s(
		{
			trig = "*3",
			name = "cubed exponent",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, t("^3")),
	s(
		{
			trig = "*4",
			name = "quartic exponent",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, t("^4")),
	s(
		{
			trig = "*5",
			name = "quintic exponent",
			wordTrig = false,
			snippetType = "autosnippet",
			condition = function(_, _, _)
				return is_math_mode()
			end
		}, t("^5")),
	s(
		{
			trig = "#",
			name = "code (inline math)",
			desc = "Tells tree-sitter that we are in a code block, to prevent completing math elements.",
			wordTrig = false,
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
	-- document templates
	--------------------------------
	--------------------------------
	s({ trig = "book", desc = "New notes template" }, fmt([[
	#import "@preview/mousse-notes:1.1.0": *
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
