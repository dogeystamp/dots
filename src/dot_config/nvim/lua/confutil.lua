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
		buffer = params.buffer,
        desc = params.desc,
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

--- True if DOTS_SETUP is set.
---
--- When true, headlessly ensure all plugins are up to date.
M.setup_mode = os.getenv("DOTS_SETUP") and true or false

local lazy_funs = {}

--- Call a function lazily.
---@param f function
---@param opts table
---@diagnostic disable-next-line: unused-local
function M.add_lazy(f, opts)
    lazy_funs[#lazy_funs+1] = f
end

vim.api.nvim_create_augroup("Lazy", { clear = true })
local function dispatch_lazy()
    for _, f in ipairs(lazy_funs) do
        f()
    end
    vim.api.nvim_del_augroup_by_name("Lazy")
end
vim.api.nvim_create_autocmd("InsertEnter", {
    group = "Lazy",
    callback = dispatch_lazy,
})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "Lazy",
    callback = dispatch_lazy,
})

return M
