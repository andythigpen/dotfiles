-- configuration for lualine

local lualine = require("lualine")

local function mode_format(str)
	local mode = str:sub(1, 1)
	if vim.api.nvim_get_option("paste") then
		mode = mode .. " (PASTE)"
	end
	return mode
end

local function term_running(name)
	local ok, terminal = pcall(require, "user.terminal")
	if ok then
		return terminal.is_running(name)
	end
	return false
end

lualine.setup({
	options = {
		globalstatus = true,
	},
	extensions = { "fugitive", "nvim-tree", "quickfix", "aerial", "ultest" },
	sections = {
		lualine_a = {
			-- shorten the mode output to just the first character
			{ "mode", fmt = mode_format },
		},
		lualine_c = {
			-- display relative filename paths
			{ "filename", path = 1 },
		},
		lualine_x = {
			{
				"ultest",
				cond = function()
					return vim.call("ultest#is_test_file") == 1
				end,
			},
			"terminal",
			{
				"terminal",
				term_name = "term1",
				icon_running = "",
				icon_default = "",
				cond = function()
					return term_running("term1")
				end,
			},
			{
				"terminal",
				term_name = "term2",
				icon_running = "",
				icon_default = "",
				cond = function()
					return term_running("term2")
				end,
			},
			"encoding",
			"fileformat",
			"filetype",
		},
	},
})

-- the status line already shows the mode
vim.cmd([[set noshowmode]])
