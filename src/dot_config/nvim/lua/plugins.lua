-- plugin installation
-- (requires nvim v0.12)

-- plugins are lazily loaded using :packadd later.
-- this file is separate so that chezmoi can trigger an update when the plugin
-- list is modified.

local confutil = require("confutil")

vim.pack.add({
        { src = "https://github.com/ledger/vim-ledger.git",          version = "46b4b1158a6304285cab8917a4cd89f641ad8f0f" },
        { src = "https://github.com/junegunn/fzf.vim",               version = "b9624aa012ddcbae9e79964bfd30cc1fbe3cf263" },
        { src = "https://github.com/airblade/vim-gitgutter",         version = "21c977e8597c468c7dc76001389b0b430d46a4b0" },
        { src = "https://github.com/L3MON4D3/LuaSnip",               version = "642b0c595e11608b4c18219e93b88d7637af27bc" },
        { src = "https://github.com/saghen/blink.cmp",               version = "78336bc89ee5365633bcf754d93df01678b5c08f" },
        { src = "https://github.com/altermo/ultimate-autopair.nvim", version = "6b58234de921437836efe27714b2026ed2ee235a" },
    },
    -- plugins are only loaded on :packadd (for lazy loading)
    {
        load = function() end,
        -- on setup, run headlessly
        confirm = not confutil.setup_mode,
    }
)
