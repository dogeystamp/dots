-- telescope without telescope
-- depends on: fzf, bat, rg

M = {}

--------------------------------
-- helpers
--------------------------------

---Hacky debug print utility (do not use outside testing)
---@param s any Thing to print
---@param pre string? Message that goes before thing
---@deprecated
---@diagnostic disable-next-line: unused-function, unused-local
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
---@field mode ("window" | "float")? Sets the window used to show the scope. Defaults to "window".
---  - "window": fills the entire window
---  - "float": floating window
---@field float_opts vim.api.keyset.win_config? Options to pass to `nvim_open_win` if mode is set to "float".

---Generic brand fuzzy selector
---@param choice_gen string | function Lua function or shell command that generates choices to display in fzf.
---@param command string | function Vim command or Lua function to run on the selected choice.
---@param scope_opts ScopeOpts | nil
function M.scope_fzf(choice_gen, command, scope_opts)
	local opts = scope_opts or {}

	local win_mode = opts.mode or "window"

	local buf = vim.api.nvim_create_buf(false, true)
	if win_mode == "window" then
		vim.api.nvim_win_set_buf(0, buf)
	elseif win_mode == "float" then
		vim.api.nvim_open_win(buf, true,
			opts.float_opts or { relative = "cursor", width = 40, height = 20, col = 1, row = 1 })
	end

	vim.wo.statusline = "Scope"

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

    -- https://github.com/mikesmithgh/kitty-scrollback.nvim/issues/295
	vim.fn.termopen(fzf_cmd, {
		on_exit = function()
			local f = io.open(stdout_file, "r")
			assert(f, "Stdout file could not be opened.")

			if win_mode == "window" then
				vim.cmd("bp | bd! #") -- see https://stackoverflow.com/a/4468491
			elseif win_mode == "float" then
				vim.api.nvim_win_close(0, false)
			end

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
	-- HACK: startinsert is broken here if called after input_new()
	vim.api.nvim_feedkeys("i", "n", false)
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
local function select_new(items, opts, on_choice)
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
			fzf_opts = string.format("--border=rounded --border-label '%s'", (opts.prompt or "Select")),
			mode = "float",
			float_opts = { relative = "cursor", width = 70, height = #items + 4, col = 1, row = 1 }
		}
	)
end

--- Replacement for `vim.ui.input`.
---@param opts table? Additional options. See |input()|
---     - prompt (string|nil)
---     - default (string|nil)
---@param on_confirm function ((input|nil) -> ())
local function input_new(opts, on_confirm)
	vim.validate({
		opts = { opts, 'table', true },
		on_confirm = { on_confirm, 'function', false },
	})

	opts = (opts and not vim.tbl_isempty(opts)) and opts or vim.empty_dict()

	opts.on_confirm = opts.on_confirm or function() end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(buf, true,
		{
			relative = "cursor",
			width = 30,
			height = 1,
			col = 1,
			row = 1,
			border = "rounded",
			title = opts.prompt,
		})

	if opts.default then
		vim.api.nvim_buf_set_lines(buf, 0, 1, true, { opts.default })
	end

	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.cmd [[startinsert!]]

	local map_opts = { noremap = true, buffer = buf }

	local function close_win()
		vim.api.nvim_win_close(0, false)
		vim.cmd.stopinsert()
	end

	vim.keymap.set({ "i", "n" }, "<Enter>",
		function()
			close_win()
			on_confirm(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, true), "\n"))
		end,
		map_opts
	)
	vim.keymap.set({ "i" }, "<C-c>", function()
		close_win()
		on_confirm(nil)
	end, map_opts)
end

---Sets up `vim.ui` hooks to use scope.
function M.setup()
	vim.ui.select = select_new
	vim.ui.input = input_new
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
			local bufnr = string.match(s, "^%s*(%d+)")
			if bufnr then
				vim.cmd.buf(bufnr)
			end
		end
	)
end

---Live fuzzy search
function M.fzf_search()
	M.scope_fzf(string.format("rg --with-filename --column --null '.' ."), function(sel)
		local _, idx_end1, search_str = string.find(sel, "([^\n]*)\n")
		local _, idx_end2, file = string.find(sel, "([%g ]*)\0", idx_end1 + 1)
		if not file then return end
		local line, column = string.match(sel, "(%d+):(%d+)", idx_end2 + 1)

		vim.cmd.drop(file)
		vim.fn.cursor(tonumber(line), tonumber(column))
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(("/%s<CR>"):format(search_str), true, false, true), "n",
			true)
	end, { fzf_opts = "--print-query" })
end

---Exact search (should be faster)
function M.rg_search()
	vim.ui.input({ prompt = "Query: " }, function(query)
		if not query or query == "" then return end
		M.scope_fzf(string.format("rg --with-filename --column --null '%s' .", query), function(sel)
			local _, idx_end1, search_str = string.find(sel, "([^\n]*)\n")
			local _, idx_end2, file = string.find(sel, "([%g ]*)\0", idx_end1 + 1)
			if not file then return end
			local line, column = string.match(sel, "(%d+):(%d+)", idx_end2 + 1)

			vim.cmd.drop(file)
			vim.fn.cursor(tonumber(line), tonumber(column))

			local highlight = search_str
			if highlight == "" then highlight = query end
		end, { fzf_opts = ("--exact --print-query --query '%s'"):format(query) })
	end)
end

return M
