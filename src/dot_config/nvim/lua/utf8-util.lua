--------------------------------
--------------------------------
-- hacked in utf-8 "support"
-- because nvim lua doesn't
--------------------------------
--------------------------------

local M = {}

---Returns width in columns of string
---@param s string
---@return integer
function M.mono_len(s)
	-- http://lua-users.org/wiki/LuaUnicode
	local _, cnt = string.gsub(s, "([%z\1-\127\194-\244][\128-\191]*)", "")
	return cnt
end

return M
