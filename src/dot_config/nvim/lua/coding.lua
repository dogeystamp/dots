-- stuff for coding

local confutil = require("confutil")
local keymap = confutil.keymap


------
-- syntax highlighting
------

vim.cmd.packadd("nvim-treesitter")

require 'nvim-treesitter.configs'.setup {
	sync_install = false,
	auto_install = false,
	highlight = {
		enable = true,

		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	indent = {
		enable = false
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>", -- set to `false` to disable one of the mappings
			scope_incremental = "<CR>",
			node_incremental = "<TAB>",
			node_decremental = "<S-TAB>",
		},
	},
}


--------
-- auto-pairs for brackets
--------
vim.cmd.packadd("nvim-autopairs")
local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
npairs.setup { check_ts = true, map_bs = false }

-- https://github.com/windwp/nvim-autopairs/wiki/Rules-API
npairs.add_rules({
	Rule("$", "$", "typst"):with_move(cond.done()),
	Rule("```", "```", "typst"),
	Rule("(", ")", "typst"),
	Rule('"', '"', "-vim"),
})

--------
-- custom backspace behaviour inspired by JetBrains IDEA
-- deletes lines that are just indents.
-- to circumvent this, use ctrl-backspace.
--
-- depends on: nvim-treesitter, nvim-autopairs (optional)
--------
keymap('<BS>', function()
	-- delete lines if they are solely whitespace
	local indent_baseline = require("nvim-treesitter.indent").get_indent(vim.fn.line("."))
	if indent_baseline ~= -1 then
		local line = vim.api.nvim_get_current_line()

		local WHITESPACE = {
			[" "] = 1,
			["\t"] = vim.o.shiftwidth,
		}

		local indent_size = 0
		local is_empty = true

		for c = line:len(), 1, -1 do
			local spaces = WHITESPACE[line:sub(c, c)]
			if spaces ~= nil then
				indent_size = indent_size + spaces
			else
				print(vim.inspect(line:sub(c, c)))
				is_empty = false
				break
			end
		end

		if is_empty and indent_size <= indent_baseline and indent_size > 0 then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>dd<C-o>k<C-o>A", true, false, true), "n", false)
			return
		end
	end

	-- hook into autopairs to actually backspace now.
	-- if you delete this line you have to replace `npairs.autopairs_bs()`
	-- so that a backspace is generated.
	vim.api.nvim_feedkeys(npairs.autopairs_bs(), "n", false)
end, { noremap = false, mode = { 'i' } })


------
-- diagnostics box
------
vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
})
-- fallback for if virtual text doesn't work
keymap('<leader>dx', vim.diagnostic.open_float, { noremap = true, silent = true })

local diagnostic_virtual_text = true

-- toggle diagnostic display between virtual text and virtual lines
keymap('<leader>dv', function()
	if diagnostic_virtual_text then
		vim.diagnostic.config({
			virtual_text = false,
			virtual_lines = true,
		})
		diagnostic_virtual_text = false
	else
		vim.diagnostic.config({
			virtual_text = true,
			virtual_lines = false,
		})
		diagnostic_virtual_text = true
	end
end, { noremap = true, silent = true })


--------------------------------
--------------------------------
-- language smarts (LSP and completion)
--------------------------------
--------------------------------

------
-- language server (LSP)
------

local opts = { noremap = true, silent = true }
keymap('gD', vim.lsp.buf.declaration, opts)
keymap('gd', vim.lsp.buf.definition, opts)
keymap('gK', vim.lsp.buf.hover, opts)
keymap('gi', vim.lsp.buf.implementation, opts)
keymap('gt', vim.lsp.buf.type_definition, opts)
keymap('<localleader>rn', vim.lsp.buf.rename, opts)
keymap('<localleader>ss', vim.lsp.buf.workspace_symbol, opts)
keymap('gr', vim.lsp.buf.references, opts)
keymap('<localleader>e', vim.lsp.diagnostic.show_line_diagnostics, opts)
keymap('[d', vim.lsp.diagnostic.goto_prev, opts)
keymap(']d', vim.lsp.diagnostic.goto_next, opts)
keymap('<localleader>ca', vim.lsp.buf.code_action, opts)
keymap('<localleader>f', vim.lsp.buf.format, opts)

-- find ruff config file path
local ruff_config = vim.fs.root(0, { ".git", "pyproject.toml" }) or ""

-- table declares LSPs to be set up
-- as well as settings per server (overrides defaults)
local servers = {
	pyright = {
		cmd = { 'pyright-langserver', '--stdio' },
		settings = {
			pyright = {
				-- defer to ruff
				disableOrganizeImports = true,
			},
		},
		root_markers = { 'pyproject.toml' },
		filetypes = { 'python' },
	},
	ruff = {
		cmd = { 'ruff', 'server' },
		settings = {
			format = {
				args = { "--config=" .. ruff_config },
			},
			lint = {
				args = { "--config=" .. ruff_config },
			},
		},
		root_markers = { 'pyproject.toml' },
		filetypes = { 'python' },
	},
	clangd = {
		cmd = { 'clangd', '--background-index' },
		root_markers = { 'compile_commands.json', 'compile_flags.txt' },
		filetypes = { 'c', 'cpp' },
	},
	ts_ls = {
		cmd = { 'typescript-language-server', '--stdio' },
		filetypes = { 'typescript', 'javascript' },
	},
	bashls = {
		cmd = { 'bash-language-server', 'start' },
		filetypes = { 'sh' },
	},
	cssls = {
		cmd = { 'vscode-css-language-server', '--stdio' },
		filetypes = { 'css' },
	},
	lua_ls = {
		cmd = { 'lua-language-server' },
		filetypes = { 'lua' },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
					},
				},
				diagnostics = {
					-- get it to stop complaining about luasnip
					globals = { 's', 'f', 't', "fmt", "c", "sn", "i", "rep", "d", "k", "events" },
				},
			}
		}
	},
	nushell = {
		cmd = { 'nu', '--lsp' },
		filetypes = { 'nu' },
	},
}

-- These servers are disabled by default;
-- enable with the keybind (after this table)
local optional_servers = {
	tinymist = {
		-- Typst language server. Battery-intensive
		root_markers = { '.git' },
		cmd = { 'tinymist', 'lsp' },
		filetypes = { 'typst' },
		settings = {
			formatterMode = "typstyle",
			semanticTokens = "disable",
		},
	},
	-- Rust language server. Disabled by default for security reasons
	rust_analyzer = {
		cmd = { 'rust-analyzer' },
		root_markers = { 'Cargo.toml' },
		filetypes = { 'rust' },
		settings = {
			['rust-analyzer'] = {
				check = {
					allTargets = false,
					command = "clippy",
				},
			},
		},
	},
}

keymap('<leader>l', function()
	for lsp, _ in pairs(optional_servers) do
		vim.lsp.enable(lsp)
	end
	vim.notify("Enabled optional language servers.", vim.log.levels.INFO)
	vim.cmd.doautocmd("BufRead")
end, { silent = false })

for lsp, sv_settings in pairs(optional_servers) do
	vim.lsp.config[lsp] = sv_settings
end
for lsp, sv_settings in pairs(servers) do
	vim.lsp.config[lsp] = sv_settings
	vim.lsp.enable(lsp)
end

--------
-- code folding
--
-- useful binds include zM (close all folds), zA (recursively toggle fold), and zR (open all folds).
-- see :h usr_28 for more information about folds.
--------
vim.cmd.packadd("promise-async")
vim.cmd.packadd("nvim-ufo")
local ufo = require("ufo")
ufo.setup()
vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- set to '1' to get a column with arrows for folds
vim.o.foldcolumn = '0'
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
keymap('zM', ufo.closeAllFolds)
keymap('zR', ufo.openAllFolds)
keymap('zm', ufo.closeFoldsWith)
keymap('zr', ufo.openFoldsExceptKinds)

------
-- completions
------
vim.cmd.packadd("nvim-cmp")
vim.cmd.packadd("cmp-nvim-lsp")

local cmp = require('cmp')
cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-f>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
	}),
})
