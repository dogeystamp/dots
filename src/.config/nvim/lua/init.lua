--------------------------------
--------------------------------
-- miscellaneous plugins
--------------------------------
--------------------------------

------
-- url motions
-- plug: urlview.nvim
------
require("urlview").setup({
	jump = {
		prev = "<leader>uj",
		next = "<leader>uh",
	},
})


------
-- fancy prompts
-- plug: dressing.nvim
------
require('dressing').setup({
	input = {
		insert_only = false,
	}
})



--------------------------------
--------------------------------
-- imports (see .config/nvim/lua/)
--------------------------------
--------------------------------

require("coding")
