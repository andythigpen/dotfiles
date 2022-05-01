local keymap = vim.keymap.set
local bdn9_installed, bdn9 = pcall(require, "user.bdn9")
local coverage_installed, coverage = pcall(require, "coverage")

-- configure vim-test
vim.cmd([[
let test#strategy = 'dispatch'
let test#enabled_runners = ["ruby#rspec", "python#pytest", "rust#cargotest"]
let test#python#pytest#options = '--cov'
]])

-- configure ultest
-- iterm doesn't display the default correctly for some reason
vim.g.ultest_running_sign = "羽"
-- let the subprocess think it's in an interactive session so it will print out colors, etc.
vim.g.ultest_use_pty = 1

-- module functions
local M = {}

function M.update_test_status()
	local status = vim.call("ultest#status")
	if status.running > 0 then
		vim.defer_fn(M.update_test_status, 500)
		return
	end
	if bdn9_installed then
		if status.failed > 0 then
			bdn9.test_failed()
		elseif status.passed > 0 then
			bdn9.test_passed()
		end
	end
	if coverage_installed then
		-- automatically display coverage after running tests
		coverage.load(true)
	end
end

function M.test(cmd)
	pcall(vim.cmd, cmd)
	-- no current way to know when vim-test is done
end

function M.ultest(cmd)
	pcall(vim.cmd, cmd)
	if bdn9_installed and bdn9.is_enabled() then
		bdn9.test_running()
		vim.defer_fn(M.update_test_status, 500)
	end
end

function M.clear()
	pcall(vim.cmd, "UltestClear")
	if bdn9_installed then
		bdn9.test_clear()
	end
end

local function ultest(cmd)
	return function()
		M.ultest(cmd)
	end
end

local function test(cmd)
	return function()
		M.test(cmd)
	end
end

-- keymaps for navigating to failed tests
keymap("n", "]t", "<Plug>(ultest-next-fail)")
keymap("n", "[t", "<Plug>(ultest-prev-fail)")

-- keymaps for running tests & displaying results
keymap("n", "<space>tt", ":UltestSummary<CR>", { silent = true })
keymap("n", "<space>tn", ultest("UltestNearest"), { silent = true })
keymap("n", "<space>tf", ultest("Ultest"), { silent = true })
keymap("n", "<space>ts", test("TestSuite"), { silent = true })
keymap("n", "<space>tl", ultest("UltestLast"), { silent = true })
keymap("n", "<space>tc", M.clear, { silent = true })

return M
