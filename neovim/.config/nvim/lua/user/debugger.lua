local keymap = vim.keymap.set

local dap = require("dap")
local dapui = require("dapui")
local bdn9 = require("user.bdn9")

dapui.setup()

local debugger_tabpage = nil

local open = function()
	vim.cmd("tabnew %")
	debugger_tabpage = vim.api.nvim_get_current_tabpage()
	dapui.open()
	bdn9.debug_mode_start()
end

local close = function()
	vim.api.nvim_set_current_tabpage(debugger_tabpage)
	dapui.close()
	vim.cmd("tabclose")
	debugger_tabpage = nil
	bdn9.debug_mode_end()
end

local continue = function()
	if debugger_tabpage then
		vim.api.nvim_set_current_tabpage(debugger_tabpage)
	else
		open()
	end
	dap.continue()
end

local terminate = function()
	if debugger_tabpage then
		close()
	end
	dap.terminate()
end

-- configure adapters
dap.adapters.ruby = {
	type = "executable",
	command = "ruby",
	args = { "readapt", "stdio" },
}

-- customize signs
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "WarningMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "WarningMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "SpellRare", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "MatchParen", linehl = "CursorLine", numhl = "" })

-- load configurations from launch.json
require("dap.ext.vscode").load_launchjs()

-- keymappings
keymap("n", "<F2>", terminate, { silent = true })
keymap("n", "<F3>", terminate, { silent = true })
keymap("n", "<F4>", dap.restart, { silent = true })
keymap("n", "<F5>", continue, { silent = true })
keymap("n", "<F6>", dap.pause, { silent = true })
keymap("n", "<F9>", dap.toggle_breakpoint, { silent = true })
keymap("n", "<leader><F9>", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { silent = true })
keymap("n", "<F10>", dap.step_over, { silent = true })
keymap("n", "<F11>", dap.step_into, { silent = true })
keymap("n", "<F12>", dap.step_out, { silent = true })
