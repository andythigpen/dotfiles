local keymap = vim.keymap.set
-- TODO: figure out a way to load coverage automatically
-- local bdn9_installed, bdn9 = pcall(require, "user.bdn9")
-- local coverage_installed, coverage = pcall(require, "coverage")

-- configure vim-test
vim.cmd([[
let test#strategy = 'dispatch'
let test#enabled_runners = ["ruby#rspec", "python#pytest", "rust#cargotest"]
let test#python#pytest#options = '--cov'
]])

-- configure neotest
local neotest = require("neotest")
neotest.setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
			args = { "--cov" },
		}),
		require("neotest-vim-test")({
			ignore_file_types = { "python", "vim", "lua" },
		}),
		require("neotest-jest")({
			jestCommand = "npm test --",
		}),
		require("neotest-go")({
			args = { "-race", "-covermode=atomic", "-coverprofile=coverage.out" },
		}),
	},
	icons = {
		running = "羽",
	},
})

-- module functions
local M = {}

function M.test(cmd)
	pcall(vim.cmd, cmd)
	-- no current way to know when vim-test is done
end

-- local function test(cmd)
-- 	return function()
-- 		M.test(cmd)
-- 	end
-- end

-- keymaps for navigating to failed tests
keymap("n", "]t", function()
	neotest.jump.next({ status = "failed" })
end)
keymap("n", "[t", function()
	neotest.jump.prev({ status = "failed" })
end)

-- keymaps for running tests & displaying results
-- keymap("n", "<space>tt", neotest.summary.toggle, { silent = true })
keymap("n", "<space>tn", neotest.run.run, { silent = true })
keymap("n", "<space>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { silent = true })
keymap("n", "<space>ts", neotest.summary.toggle, { silent = true })
keymap("n", "<space>tl", neotest.run.run_last, { silent = true })
-- keymap("n", "<space>tc", M.clear, { silent = true })

return M
