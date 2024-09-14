-- configuration utility functions and variables

local M = {}

---@class KeymapOpts: vim.keymap.set.Opts
--- @field mode? string|string[]

---Keymap helper.
---@param key string
---@param cmd string|function
---@param params? KeymapOpts
function M.keymap(key, cmd, params)
	if params == nil then
		params = {}
	end

	if cmd == nil then
		-- sometimes a function will be there, sometimes not
		return
	end

	local default_params = {
		silent = true,
		mode = { 'n' },
		noremap = true,
		buffer = false,
	}
	setmetatable(params, {
		__index = function(_, k)
			return default_params[k]
		end
	})

	vim.keymap.set(params.mode, key, cmd, {
		silent = params.silent,
		noremap = params.noremap,
		expr = params.expr,
		buffer = params.buffer
	})
end

-- see ~/.config/dot_profile.example for info
-- enables/disables features based on system profile
M.profile_table = {
	DEFAULT = 80,
	SLIM = 40,
	MINIMAL = 10,
}
M.dotprofile = M.profile_table[os.getenv("SYSTEM_PROFILE")] or M.profile_table.SLIM

return M
