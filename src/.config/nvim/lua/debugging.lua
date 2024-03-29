-- dap and debugging related configurations

local confutil = require("confutil")
local keymap = confutil.keymap

local dap = require("dap")
local dapui = require("dapui")

--------------------------------
--------------------------------
-- dap-ui configuration
--------------------------------
--------------------------------

----------------
-- key bindings
----------------

keymap("<leader>rs", dap.continue)
keymap("<leader>rt", function()
	-- hard restart (lldb just stops when restarted)
	dap.terminate()
	dap.continue()
end)
keymap("<leader>rr", dap.terminate)
keymap("<c-p>", dap.step_into)
keymap("<c-n>", dap.step_over)
keymap("<F12>", dap.step_out)
keymap("<leader>dsf", dap.toggle_breakpoint)
keymap("<leader>dsc", dap.clear_breakpoints)
keymap("<leader>dsF", function()
	dap.set_breakpoint(vim.fn.input("cond: "))
end)
keymap("K", dapui.eval, {mode = {'n', 'v'}})

----------------
-- ui setup
----------------

-- https://github.com/rcarriga/nvim-dap-ui/blob/master/doc/nvim-dap-ui.txt
dapui.setup({
	controls = {
		enabled = false,
	},
	icons = {
		collapsed = ">",
		current_frame = ">",
		expanded = "v",
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

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
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
		type = "python";
		request = "launch";
		name = "launch file";

		-- debugger parts
		program = "${file}";
		-- this could be smarter (e.g., try to find a virtual env)
		pythonPath = function() return "/usr/bin/python" end;
		console = "integratedTerminal";
	}
}

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-gdb
dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode",
	name = "lldb"
}

dap.configurations.cpp = {
	{
		name = "launch binary",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("binary: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		runInTerminal = true,
	}
}
