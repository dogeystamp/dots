-- telescope without telescope
-- depends on: fzf, bat

M = {}

--------------------------------
-- helpers
--------------------------------

---Hacky debug print utility (do not use outside testing)
---@param s any Thing to print
---@param pre string? Message that goes before thing
local function dbg_print(s, pre)
	vim.system({ "sh", "-c", string.format("echo '%s' >> /tmp/nvim_scope_log", (pre or "") .. vim.inspect(s)) })
end


--------------------------------
--------------------------------
-- main implementation
--------------------------------
--------------------------------

---@class ScopeOpts
---@field fzf_opts string? Command-line flags to pass to fzf.
---@field allow_empty boolean? If true, will call `command` even if user cancelled. Defaults to false.

---Generic brand fuzzy selector
---@param choice_gen string | function Lua function or shell command that generates choices to display in fzf.
---@param command string | function Vim command or Lua function to run on the selected choice.
---@param scope_opts ScopeOpts | nil
function M.scope_fzf(choice_gen, command, scope_opts)
	local opts = scope_opts or {}

	local buf = vim.api.nvim_create_buf(false, true)
	vim.cmd.buf(buf)

	vim.wo.statusline = "Scope"

	vim.cmd("startinsert")

	local fzf_opts = opts.fzf_opts or ""

	local choice_cmd = ""
	local choices_file = nil
	if type(choice_gen) == "string" then
		choice_cmd = choice_gen .. " | "
	elseif type(choice_gen) == "function" then
		choices_file = vim.fn.tempname()
		local f = io.open(choices_file, "w")
		assert(f, "Stdin file could not be opened.")
		f:write(choice_gen())
		choice_cmd = "cat " .. choices_file .. " | "
		f:close()
	end

	local stdout_file = vim.fn.tempname()

	local fzf_cmd = choice_cmd .. "fzf " .. fzf_opts .. " > " .. stdout_file
	dbg_print(fzf_cmd, "fzf_cmd: ")

	vim.fn.termopen(fzf_cmd, {
		on_stdout = function(_, b, _)
			dbg_print(b, "stdout: ")
		end,
		on_exit = function()
			local f = io.open(stdout_file, "r")
			assert(f, "Stdout file could not be opened.")
			vim.cmd("bp | bd! #") -- see https://stackoverflow.com/a/4468491
			local stdout = f:read("*all")
			f:close()
			os.remove(stdout_file)
			if choices_file then
				os.remove(choices_file)
			end

			if (stdout and stdout ~= "") or opts.allow_empty then
				if type(command) == "function" then
					command(stdout)
				elseif type(command) == "string" then
					vim.cmd(command .. stdout)
				end
			end
		end
	})
end

--------------------------------
--------------------------------
-- vim.ui overwrites
--------------------------------
--------------------------------

--- Replacement for `vim.ui.select`.
---@param items any[] Arbitrary items
---@param opts table? Additional options
---     - prompt (string|nil)
---     - format_item (function item -> text)
---     - kind (string|nil)
---@param on_choice fun(item: any|nil, idx: integer|nil)
local function picker(items, opts, on_choice)
	vim.validate({
		items = { items, 'table', false },
		on_choice = { on_choice, 'function', false },
	})
	opts = opts or {}

	M.scope_fzf(
		function()
			---@type string[]
			local items_fmt = {}

			local fmt = opts.format_item or tostring
			for i, v in ipairs(items) do
				table.insert(items_fmt, string.format("%d: %s", i, fmt(v)))
			end

			return table.concat(items_fmt, "\n")
		end,
		function(sel)
			if not sel or sel == "" then
				on_choice(nil, nil)
				return
			end

			local _, _, idx_str = string.find(sel, "^(%d+):")
			local idx = tonumber(idx_str)
			assert(idx, "Could not parse fzf output.")
			on_choice(items[idx], idx)
		end,
		{
			allow_empty = true,
			fzf_opts = string.format("--border=rounded --border-label '%s'", (opts.prompt or "Select"))
		}
	)
end

---Sets up `vim.ui` hooks to use scope.
function M.setup()
	vim.ui.select = picker
end

--------------------------------
--------------------------------
-- preset modes
--------------------------------
--------------------------------

---Find and open a file.
function M.file_finder()
	M.scope_fzf(
		"rg --files",
		":e ",
		{ fzf_opts = '--preview "bat --color always --line-range=:500 {}"' }
	)
end

---List and navigate buffers
function M.buffer_list()
	M.scope_fzf(
		function()
			return vim.api.nvim_exec2("ls", { output = true }).output
		end,
		function(s)
			local _, _, bufnr = string.find(s, "^%s*(%d+)")
			if bufnr then
				vim.cmd.buf(bufnr)
			end
		end
	)
end

return M
