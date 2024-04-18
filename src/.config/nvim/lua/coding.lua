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
vim.api.nvim_create_augroup("AutoFormat", {})

vim.api.nvim_create_autocmd(
	"BufWritePost",
	{
		pattern = "*.py",
		group = "AutoFormat",
		callback = function()
			vim.cmd("silent !black --quiet %")
			vim.cmd("edit")
			vim.cmd("norm zz")
		end,
	}
)


------
-- syntax highlighting
-- plug: nvim-treesitter
------
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "cpp", "javascript", "typescript", "python", "vim", "fish", "bash", "lua", "rust" },
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
}

------
-- treesitter (language intelligent) motions
-- plug: nvim-treesitter-textobjects
------
require("nvim-treesitter.configs").setup {
	textobjects = {
		select = {
			enable = true,

			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		}
	}
}


------
-- diagnostics box
-- plug: trouble.nvim
------
require('trouble').setup({
	icons = false,
	fold_open = "v",   -- icon used for open folds
	fold_closed = ">", -- icon used for closed folds
	indent_lines = false, -- add an indent guide below the fold icons
	signs = {
		-- icons / text used for a diagnostic
		error = "error",
		warning = "warn",
		hint = "hint",
		information = "info"
	},
	use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
})
keymap("<leader>dxx", "<cmd>TroubleToggle<cr>")
keymap("<leader>dxw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
keymap("<leader>dxd", "<cmd>TroubleToggle document_diagnostics<cr>")
keymap("<leader>dxq", "<cmd>TroubleToggle quickfix<cr>")
keymap("<leader>dxl", "<cmd>TroubleToggle loclist<cr>")
keymap("gR", "<cmd>TroubleToggle lsp_references<cr>")



--------------------------------
--------------------------------
-- language smarts (LSP and completion)
--------------------------------
--------------------------------

------
-- language server (LSP)
-- plug: nvim-lspconfig
------
local on_attach = function(client, bufnr)
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap = true, silent = true, buffer=bufnr }
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

-- table declares LSPs to be set up
-- as well as settings per server (overrides defaults)
local servers = {
	pyright = {},
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
	tsserver = {},
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
}
local nvim_lsp = require('lspconfig')
for lsp, sv_settings in pairs(servers) do
	-- defaults
	local settings = {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		}
	}
	for k, v in pairs(servers[lsp]) do settings[k] = v end
	nvim_lsp[lsp].setup(settings)
end


------
-- completions
-- plug: nvim-cmp, cmp-nvim-lsp
------
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
