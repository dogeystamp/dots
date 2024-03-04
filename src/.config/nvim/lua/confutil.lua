-- configuration utility functions and variables

local M = {}

-- nnoremap, etc.
function M.keymap(key, cmd, params)
	if params == nil then
		params = {}
	end

	default_params = {
		silent=true,
		mode="n",
		noremap=true,
	}
	setmetatable(params, {
		__index = function (table, key)
			return default_params[key]
		end
	})

	vim.api.nvim_set_keymap(params.mode, key, cmd, { silent=params.silent, noremap=params.noremap })
end

-- see ~/.config/dot_profile.example for info
-- enables/disables features based on system profile
M.profile_table = {
	DEFAULT=80,
	SLIM=40,
	MINIMAL=10,
}
M.dotprofile = M.profile_table[os.getenv("SYSTEM_PROFILE")] or profile_table.SLIM

return M
