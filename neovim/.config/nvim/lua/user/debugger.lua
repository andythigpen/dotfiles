local keymap = vim.keymap.set

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

local debugger_tabpage = nil

local open = function()
    vim.cmd("tabnew %")
    debugger_tabpage = vim.api.nvim_get_current_tabpage()
    dapui.open()
end

local close = function()
    if debugger_tabpage == nil then
        return
    end
    vim.api.nvim_set_current_tabpage(debugger_tabpage)
    dapui.close()
    vim.cmd("tabclose")
    debugger_tabpage = nil
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

-- focus the tab when the debugger stops
dap.listeners.before["event_stopped"]["user"] = function()
    if debugger_tabpage then
        vim.api.nvim_set_current_tabpage(debugger_tabpage)
    end
end

-- configure adapters
dap.adapters.ruby = {
    type = "executable",
    command = "ruby",
    args = { vim.fn.exepath("readapt"), "stdio" },
}
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode-13',
    name = 'lldb'
}

-- configurations
dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
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
