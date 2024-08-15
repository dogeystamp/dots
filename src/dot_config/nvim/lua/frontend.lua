--------------------------------
--------------------------------
-- gui frontend settings
--------------------------------
--------------------------------

vim.o.guifont = "JetBrainsMono NF:h10"

if vim.g.neovide then
	local confutil = require("confutil")
	local keymap = confutil.keymap

	vim.g.neovide_padding_top = 8
	vim.g.neovide_padding_bottom = 8
	vim.g.neovide_padding_left = 8
	vim.g.neovide_transparency = 1.0
	vim.g.neovide_background_color = "#000000" .. 0

	vim.g.neovide_cursor_trail_size = 0.1
	vim.g.neovide_cursor_animate_in_insert_mode = true

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
	keymap("<C-S-V>", '<Esc>"+pa', { mode = { "n", "i", "v" } })
	-- this bind seems to not show the pasted text until the screen is updated, but it works i guess
	keymap("<C-S-V>", '<c-r>+', { mode = { "c" } })

	-- "new-term" in working directory
	keymap("<C-S-Return>", function()
		vim.system({ 'sh', '-c', 'alacritty msg create-window --working-directory "$(pwd)" || alacritty' },
			{ detach = true })
	end, { mode = { "n", "i", "v", "t", "c" } })
end
