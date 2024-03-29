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

keymap("<leader>dd", dapui.setup)
keymap("<leader>rs", dap.continue)
keymap("<leader>rt", dap.restart)
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
					id = "repl",
					size = 1
				},
			},
			position = "bottom",
			size = 10
		},
		{
			elements = {
				{
					id = "console",
					size = 1
				}
			},
			position = "right",
			size = 50
		},
	},
})

dap.listeners.after.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.after.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.after.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.after.event_exited.dapui_config = function()
	dapui.close()
end


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
