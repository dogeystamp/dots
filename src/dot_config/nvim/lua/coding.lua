-- stuff for coding

local confutil = require("confutil")
local keymap = confutil.keymap


------------------
-- LSP binds
-- these are helix-inspired
------------------

-- note that LSP is disabled by default until <space>l or :lsp enable.

-- there are also some default binds that are useful:
-- *  CTRL-s (insert mode): signature help
-- *  an (visual mode): incremental select
-- see :help lsp-default for more info.

local opts = { noremap = true, silent = true }
keymap('<localleader>l', function()
    vim.cmd [[:lsp enable]]
    vim.notify("Enabled LSP.")
end, opts)

-- unset default LSP binds that conflict with ours
vim.cmd [[nnoremap <nowait> gr gr]]

keymap('gr', vim.lsp.buf.references, opts)
keymap('gd', vim.lsp.buf.definition, opts)
keymap('gy', vim.lsp.buf.type_definition, opts)
keymap('gi', vim.lsp.buf.implementation, opts)

keymap('<localleader>r', vim.lsp.buf.rename, opts)
keymap('<localleader>a', vim.lsp.buf.code_action, opts)
keymap('<localleader>x', vim.lsp.codelens.run, opts)
keymap('<leader>f', vim.lsp.buf.format, opts)


--------------------
-- diagnostics
--------------------
local sev = vim.diagnostic.severity
vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false,
    signs = {
        severity_sort = true,
        text = {
            [sev.ERROR] = '󰜡',
            [sev.WARN] = '󰛸',
            [sev.INFO] = '󰋽',
            [sev.HINT] = '󰘥',
        },
    },
})
-- fallback for if virtual text doesn't work
keymap('<localleader>dx', vim.diagnostic.open_float, { noremap = true, silent = true })

local diagnostic_virtual_text = true

-- toggle diagnostic display between virtual text and virtual lines
keymap('<localleader>dv', function()
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



------
-- language server (LSP)
-- see ~/.config/nvim/lsp/ for full configurations taken from nvim-lspconfig.
-- the following options override the lsp/ configurations.
------
vim.lsp.config("rust_analyzer", {
    settings = {
        ['rust-analyzer'] = {
            check = {
                allTargets = false,
                command = "clippy",
            },
        },
    },
})
vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                version = 'LuaJIT',
                -- see `:h lua-module-load`
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library',
                    -- '${3rd}/busted/library',
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end,
    settings = {
        Lua = {},
    },
})


--------
-- code folding
--
-- useful binds include zM (close all folds), zA (recursively toggle fold), and zR (open all folds).
-- see :h usr_28 for more information about folds.
--------
vim.o.foldenable = false
vim.o.foldmethod = "expr"
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldcolumn = '0'
vim.o.foldtext = ""
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-----------------
-- completions
-----------------
vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = "78336bc89ee5365633bcf754d93df01678b5c08f" },
})
require("blink.cmp").setup({
    keymap = { preset = "super-tab" },
    fuzzy = { implementation = "lua" },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
        },
        menu = {
            auto_show_delay_ms = 200,
        },
        ghost_text = {
            enabled = true,
            show_with_menu = true,
        },
    },
    snippets = { preset = "luasnip" },
    sources = {
        -- notable exceptions: path, snippet, buffer
        -- i think these clutter the completions
        default = { 'lsp' },
    },
})

------------------------------
--- auto-pair brackets
------------------------------

require("ultimate-autopair").setup({
    { '$', '$', ft = { "typst", newline = true } },
    config_internal_pairs = {
        { '```', '```', newline = true, ft = { "markdown", "typst" } },
    },
})

----------------------------
-- git gutter / sign column
----------------------------

vim.pack.add({
    { src = "https://github.com/airblade/vim-gitgutter", version = "21c977e8597c468c7dc76001389b0b430d46a4b0" },
})
vim.g.gitgutter_sign_added = '▐'
vim.g.gitgutter_sign_modified = '▐'
vim.g.gitgutter_sign_removed = '▐'
vim.g.gitgutter_sign_removed_first_line = '▐'
vim.g.gitgutter_sign_removed_above_and_below = '▐'
vim.g.gitgutter_sign_modified_removed = '▐'
vim.cmd.packadd("vim-gitgutter")
