--------------------------------
--------------------------------
-- gui frontend settings
--------------------------------
--------------------------------

vim.o.guifont = "JetBrains Mono:h10"

if vim.g.neovide then
	local confutil = require("confutil")
	local keymap = confutil.keymap

	vim.g.neovide_padding_top = 8
	vim.g.neovide_padding_bottom = 8
	vim.g.neovide_padding_left = 8
	vim.g.transparency = 0
	vim.g.neovide_background_color = "#000000" .. 0

	vim.g.neovide_cursor_animate_in_insert_mode = false

	-- hack to unscrew the scaling issues
	-- sometimes opening neovide on a tiling wm makes it not occupy the entire window until resized
	vim.api.nvim_create_augroup("NeovideScale", {})
	vim.api.nvim_create_autocmd(
		"FocusGained",
		{
			group = "NeovideScale",
			once = true,
			callback = function()
				vim.g.neovide_scale_factor = 1.01
				vim.uv.new_timer():start(40, 0, vim.schedule_wrap(function()
					vim.g.neovide_scale_factor = 1
				end))
			end,
		}
	)

	-- no terminal, no Ctrl-Shift-V paste
	keymap("<C-S-V>", '<Esc>"+p', { mode = { "n", "i" } })

	-- "new-term" in working directory
	keymap("<C-S-Return>", function()
		vim.system({ 'alacritty' }, { detach = true })
	end, { mode = { "n", "i", "v", "t" } })
end
