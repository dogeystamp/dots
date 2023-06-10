-- Syntax highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "javascript", "typescript", "python", "vim", "fish", "bash" },
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

-- motions to hop between URLs fast
require("urlview").setup({
	jump = {
		prev = "<leader>uj",
		next = "<leader>uh",
	},
})

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gK', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

-- settings per server (overrides defaults)
local servers = {
	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					pydocstyle = {
						enabled = true,
						convention = "numpy",
						addIgnore = {"D100", "D101", "D102", "D103" ,"D105"}
					},
					black = {
						enabled = true,
					}
				}
			}
		}
	},
	clangd = {},
	tsserver = {},
}

local nvim_lsp = require('lspconfig')
for lsp, sv_settings in pairs(servers) do
	-- defaults
	settings = {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		}
	}
	for k, v in pairs(servers[lsp]) do settings[k] = v end
	nvim_lsp[lsp].setup(settings)
end

-- fancy prompts
require('dressing').setup({
	input = {
		insert_only = false,
	}
})

-- fancy motions (leap.nvim)
vim.keymap.set({'n', 'x', 'o'}, 'f', '<Plug>(leap-forward-to)')
vim.keymap.set({'n', 'x', 'o'}, 'F', '<Plug>(leap-backward-to)')
vim.keymap.set(
	{'n', 'x', 'o'}, 't',
	function ()
		require("leap").leap { offset = 2 }
	end
)
vim.keymap.set(
	{'n', 'x', 'o'}, 'T',
	function ()
		require("leap").leap { backward = true, offset = 2 }
	end
)
require('leap').opts.safe_labels = {
	"a", "s", "d", "f", "g", "h", "j", "k", "l"
}
require('leap').opts.labels = { "a", "s", "d",
	"f", "k", "l", "h", "o", "d", "w", "e", "m",
	"u", "v", "r", "g", "c", "x", "z",
}

local cmp = require'cmp'
cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
	  ['<C-e>'] = cmp.mapping.abort(),
	  ['<C-f>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
	})
})

-- improved error list
require('trouble').setup({
    icons = false,
    fold_open = "v", -- icon used for open folds
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
