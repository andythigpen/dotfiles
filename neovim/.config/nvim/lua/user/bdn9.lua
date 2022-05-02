local timer = nil
local opts = {
	enabled = false,
	executable_exists = vim.fn.executable("bdn9") == 1,
}

local M = {}

function M.clear_timer()
	if timer == nil then
		return
	end
	timer:stop()
	timer = nil
end

function M.is_enabled()
	return opts.enabled and opts.executable_exists
end

function M.test_clear()
	if not M.is_enabled() then
		return
	end
	M.clear_timer()
	vim.cmd([[
  silent !bdn9 key clear -l 1
  silent !bdn9 hsv set -m 1 0 0 20
  ]])
end

function M.test_running()
	if not M.is_enabled() then
		return
	end
	M.clear_timer()
	vim.cmd([[
  silent !bdn9 key clear -l 1
  silent !bdn9 hsv set -m 14 255 200 55
  ]])
end

function M.test_failed()
	if not M.is_enabled() then
		return
	end
	M.clear_timer()
	vim.cmd([[
  silent !bdn9 key clear -l 1
  silent !bdn9 hsv set -m 1 255 255 55
  ]])
	timer = vim.defer_fn(M.test_clear, 5000)
end

function M.test_passed()
	if not M.is_enabled() then
		return
	end
	M.clear_timer()
	vim.cmd([[
  silent !bdn9 key clear -l 1
  silent !bdn9 hsv set -m 1 85 255 55
  ]])
	timer = vim.defer_fn(M.test_clear, 5000)
end

function M.debug_mode_start()
	if not M.is_enabled() then
		return
	end
	vim.cmd([[
  silent !bdn9 key clear -l 2
  silent !bdn9 key set -l 2 -k 2 255 255 55 
  silent !bdn9 key set -l 2 -k 3 20 200 55 
  silent !bdn9 key set -l 2 -k 4 90 200 55 
  silent !bdn9 key set -l 2 -k 5 255 255 55 
  silent !bdn9 key set -l 2 -k 6 150 200 55 
  silent !bdn9 key set -l 2 -k 7 150 200 55 
  silent !bdn9 key set -l 2 -k 8 150 200 55 
  silent !bdn9 key on -l 2 2 3 4 5 6 7 8
  silent !bdn9 layer set 2
  ]])
end

function M.debug_mode_end()
	if not M.is_enabled() then
		return
	end
	vim.cmd([[
  silent !bdn9 layer set 1
  ]])
end

function M.setup()
	opts.enabled = true
end

return M
