-- dap and debugging related configurations

local confutil = require("confutil")
local keymap = confutil.keymap

-- dependency
vim.cmd.packadd("nvim-nio")

vim.cmd.packadd("nvim-dap")
vim.cmd.packadd("nvim-dap-ui")

local dap = require("dap")
local dapui = require("dapui")

local M = {}

--------------------------------
--------------------------------
-- dap-ui configuration
--------------------------------
--------------------------------

----------------
-- key bindings
----------------

keymap("<leader>rs", dap.continue)
keymap("<leader>rt", dap.restart)
keymap("<leader>rr", dap.terminate)
keymap("<F11>", dap.step_into)
keymap("<c-n>", dap.step_over)
keymap("<c-p>", dap.run_to_cursor)
keymap("<F12>", dap.step_out)
keymap("<leader>dsf", dap.toggle_breakpoint)
keymap("<leader>dsc", dap.clear_breakpoints)
keymap("<leader>dsF", function()
	dap.set_breakpoint(vim.fn.input("cond: "))
end)
keymap("K", dapui.eval, { mode = { 'n', 'v' } })

----------------
-- ui setup
----------------

-- https://github.com/rcarriga/nvim-dap-ui/blob/master/doc/nvim-dap-ui.txt
dapui.setup({
	controls = {
		enabled = false,
	},
	icons = {
		current_frame = "→",
		collapsed = "►",
		expanded = "▼",
	},
	layouts = {
		{
			elements = {
				{
					id = "stacks",
					size = 0.20
				},
				{
					id = "scopes",
					size = 0.40
				},
				{
					id = "watches",
					size = 0.40
				},
			},
			position = "left",
			size = 40
		},
		{
			elements = {
				{
					id = "console",
					size = 0.8
				},
				{
					id = "repl",
					size = 0.2
				},
			},
			position = "right",
			size = 50
		},
	},
})

----------------
-- hooks
----------------

dap.listeners.after.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.after.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

----------------
-- signs
----------------

vim.cmd [[ sign define DapBreakpoint text=● ]]
vim.cmd [[ sign define DapBreakpointCondition text=◒ ]]

--------------------------------
--------------------------------
-- debug adapter configs
--------------------------------
--------------------------------

----------------
-- debug directory utilities
----------------

local function gf(file)
	return file or vim.fn.expand("%:p")
end

function M.dbg_dir(file)
	-- get a directory to store files needed for debugging
	-- like ad hoc test cases, or compiled binaries
	local dir = assert(vim.env.XDG_CACHE_HOME, "$XDG_CACHE_HOME is unset") .. "/nvimdbg"
	file = gf(file)
	local subdir = dir .. file
	assert(vim.fn.mkdir(subdir, "p"), "Could not create debug directory.")
	return subdir
end

function M.compile(file)
	file = gf(file)
	local subdir = M.dbg_dir(file)
	vim.cmd.make(subdir .. "/binary " .. "-f $XDG_CONFIG_HOME/nvim/makefile")
end

keymap("<leader>dc", M.compile, { silent = false })

function M.write_input(file)
	-- store ad hoc test input from clipboard
	file = gf(file)
	local inp_file = M.dbg_dir(file) .. "/input"
	print(vim.fn.writefile(vim.fn.getreg("+", 1, 1), inp_file))
end

function M.run_input(file)
	file = gf(file)
	if not dapui.elements.console then
		print("Unable to feed input: no console found")
		return
	end
	vim.api.nvim_buf_call(dapui.elements.console.buffer(), function()
		vim.b.nvimdbg_inp_file = M.dbg_dir(file) .. "/input"
		vim.cmd [[
		" 0x4 is eof
		let @x = join(readfile(b:nvimdbg_inp_file), "\n") .. "\n\n" .. "\x04"
		normal! G"xp
		]]
	end)
end

keymap("<leader>rw", M.write_input)
keymap("<leader>ri", M.run_input)

function M.run_tests(file)
	file = gf(file)
	local executable
	if vim.fn.expand("%:e") == "cpp" then
		executable = M.dbg_dir(file) .. "/binary"
	else
		executable = vim.fn.expand("%:p")
	end

	vim.cmd.vsplit()
	vim.w.nvimdbg_testdir = M.dbg_dir(file) .. "/tests"
	vim.w.nvimdbg_exec = executable
	vim.cmd [[
		vertical resize 40
		normal G
		silent exec "!mkdir -p " .. w:nvimdbg_testdir
		exec 'terminal ' .. 'testr --exec ' .. w:nvimdbg_exec .. " --testdir " .. w:nvimdbg_testdir
		exec "norm \<c-w>h"
	]]
end

keymap("<leader>dt", M.run_tests)


----------------
-- python
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
----------------
dap.adapters.python = function(cb, config)
	if config.request == 'attach' then
		assert(false, "attach not implemented")
	else
		cb({
			type = 'executable',
			command = "python",
			args = { "-m", "debugpy.adapter" },
			options = {
				source_filetype = "python",
			}
		})
	end
end

dap.configurations.python = {
	{
		-- dap parts
		type = "python",
		request = "launch",
		name = "launch file",

		-- debugger parts
		program = "${file}",
		-- this could be smarter (e.g., try to find a virtual env)
		pythonPath = function() return "/usr/bin/python" end,
		console = "integratedTerminal",
	}
}

----------------
-- c++
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-gdb
----------------
dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-dap",
	name = "lldb"
}

dap.configurations.cpp = {
	{
		name = "launch binary",
		type = "lldb",
		request = "launch",
		program = function()
			local binary = M.dbg_dir() .. "/binary"
			if not vim.fn.filereadable(binary) then
				binary = vim.fn.input("binary: ", vim.fn.getcwd() .. "/", "file")
			end

			return binary
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		runInTerminal = true,
	}
}

return M
