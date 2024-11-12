-- stuff for coding

local confutil = require("confutil")
local keymap = confutil.keymap


------
-- python format-on-save
-- https://stackoverflow.com/a/77467553
------

-- to turn this off for a session (permanently), run
-- :autocmd! AutoFormat
-- https://superuser.com/a/1415274

-- vim.api.nvim_create_augroup("AutoFormat", {})
--
-- vim.api.nvim_create_autocmd(
-- 	"BufWritePost",
-- 	{
-- 		pattern = "*.py",
-- 		group = "AutoFormat",
-- 		callback = function()
-- 			vim.cmd("silent !black --quiet %")
-- 			vim.cmd("edit")
-- 			vim.cmd("norm zz")
-- 		end,
-- 	}
-- )


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
		enable = true
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
vim.cmd.packadd("auto-pairs")

------
-- diagnostics box
------
keymap('<leader>dx', vim.diagnostic.open_float, { noremap = true, silent = true })


--------------------------------
--------------------------------
-- language smarts (LSP and completion)
--------------------------------
--------------------------------

------
-- language server (LSP)
------
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
	local function buf_set_option(name, value) vim.api.nvim_set_option_value(name, value, { buf = bufnr }) end

	if client.name == "ruff" then
		-- defer hover to pyright
		client.server_capabilities.hoverProvider = false
	end

	if client.name == "typst_lsp" then
		-- this breaks on special characters outside english
		client.server_capabilities.semanticTokensProvider = false
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap = true, silent = true, buffer = bufnr }
	keymap('gD', vim.lsp.buf.declaration, opts)
	keymap('gd', vim.lsp.buf.definition, opts)
	keymap('gK', vim.lsp.buf.hover, opts)
	keymap('gi', vim.lsp.buf.implementation, opts)
	keymap('gs', vim.lsp.buf.signature_help, opts)
	keymap('gt', vim.lsp.buf.type_definition, opts)
	keymap('<localleader>rn', vim.lsp.buf.rename, opts)
	keymap('<localleader>ss', vim.lsp.buf.workspace_symbol, opts)
	keymap('gr', vim.lsp.buf.references, opts)
	keymap('<localleader>e', vim.lsp.diagnostic.show_line_diagnostics, opts)
	keymap('[d', vim.lsp.diagnostic.goto_prev, opts)
	keymap(']d', vim.lsp.diagnostic.goto_next, opts)
	keymap('<localleader>ca', vim.lsp.buf.code_action, opts)
	keymap('<localleader>f', vim.lsp.buf.format, opts)
end

-- find ruff config file path
local ruff_config = vim.fs.root(0, { ".git", "pyproject.toml" }) or ""

vim.cmd.packadd("cmp-nvim-lsp")
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local pyright_cap = cmp_nvim_lsp.default_capabilities()
-- disable hint level diagnostics in pyright (defer to ruff)
pyright_cap.textDocument.publishDiagnostics = { tagSupport = { valueSet = { 2 } } }

-- table declares LSPs to be set up
-- as well as settings per server (overrides defaults)
local servers = {
	pyright = {
		settings = {
			pyright = {
				-- defer to ruff
				disableOrganizeImports = true,
			},
		},
		capabilities = pyright_cap,
	},
	ruff = {
		settings = {
			format = {
				args = { "--config=" .. ruff_config },
			},
			lint = {
				args = { "--config=" .. ruff_config },
			},
		}
	},
	-- pylsp = {
	-- 	settings = {
	-- 		plugins = {
	-- 			['python-lsp-black'] = {},
	-- 			['python-pyflakes'] = {},
	-- 			['pylsp-mypy'] = {},
	-- 		},
	-- 	},
	-- },
	clangd = {},
	ts_ls = {},
	bashls = {},
	cssls = {},
	lua_ls = {
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
	rust_analyzer = {
		settings = {
			['rust-analyzer'] = {
				check = {
					allTargets = false,
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	-- too battery intensive
	-- typst_lsp = {
	-- 	settings = {
	-- 		exportPdf = "onSave", -- alternatively onType / never
	-- 	}
	-- },
	nushell = {},
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
for lsp, sv_settings in pairs(servers) do
	-- defaults
	local settings = {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities=capabilities,
	}
	for k, v in pairs(servers[lsp]) do settings[k] = v end
	nvim_lsp[lsp].setup(settings)
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
