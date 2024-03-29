local keymap = vim.keymap.set

-- fixed git status height
local git_status_width = 67

local get_buffer_list = function()
	return vim.fn.filter(vim.fn.range(1, vim.fn.bufnr("$")), "buflisted(v:val)")
end

local get_matching_buffers = function(pattern)
	local buffers = get_buffer_list()
	pattern = vim.regex(pattern)
	return vim.tbl_filter(function(v)
		return pattern:match_str(vim.fn.bufname(v)) ~= nil
	end, buffers)
end

local wipe_matching_buffers = function(pattern)
	local matchlist = get_matching_buffers(pattern)
	local count = vim.tbl_count(matchlist)
	if count < 1 then
		return
	end
	vim.api.nvim_exec("bw " .. vim.fn.join(matchlist, " "), true)
end

vim.api.nvim_create_user_command("Gdiffoff", function()
	wipe_matching_buffers("fugitive://")
end, {})

local toggle_git_status = function()
	local gitdir = vim.fn.FugitiveGitDir()
	local bufname = vim.fn.bufname("fugitive://" .. gitdir .. "//")
	if vim.fn.buflisted(bufname) == 1 then
		wipe_matching_buffers("fugitive://")
	else
		vim.cmd(string.format(
			[[
                Git
                wincmd L
                %swincmd |
            ]],
			git_status_width
		))
	end
end

-- toggle status command & keymap
vim.api.nvim_create_user_command("ToggleGStatus", toggle_git_status, {})
keymap("n", "<leader>g", toggle_git_status)

-- resize the status window automatically
local augroup_id = vim.api.nvim_create_augroup("FugitiveWinSize", {})
vim.api.nvim_create_autocmd("FileType", {
	group = augroup_id,
	pattern = "fugitive",
	callback = function()
		vim.cmd("setlocal winfixwidth")
	end,
})
