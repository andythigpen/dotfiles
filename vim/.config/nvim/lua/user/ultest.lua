local ok, _ = pcall(require, "ultest")
if not ok then
	local function noop() end
	return {
		update_test_status = noop,
		test = noop,
		clear = noop,
	}
end

local bdn9 = require("user.bdn9")

local M = {}

function M.update_test_status()
	local status = vim.call("ultest#status")
	if status.running > 0 then
		vim.defer_fn(M.update_test_status, 500)
		return
	end
	if status.failed > 0 then
		bdn9.test_failed()
	elseif status.passed > 0 then
		bdn9.test_passed()
	end
end

function M.test(cmd)
	local prev_python_path = vim.env.PYTHONPATH
	vim.env.PYTHONPATH = "."
	pcall(vim.cmd, cmd)

	if bdn9.is_enabled() then
		bdn9.test_running()
		vim.defer_fn(M.update_test_status, 500)
	end

	vim.env.PYTHONPATH = prev_python_path
end

function M.clear()
	pcall(vim.cmd, "UltestClear")
	bdn9.test_clear()
end

return M
