-- Syntax highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "javascript", "python", "vim", "latex", "fish", "bash" },
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
