require("luasnip.config").setup({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
})

-- keymappings
vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("i", "<C-l>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>", {})

-- loads snippets (snipmate format) from directories named "snippets" in the runtimepath
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_lua").load()

function _G.edit_ft()
	-- returns table like {"lua", "all"}
	local fts = require("luasnip.util.util").get_snippet_filetypes()
	vim.ui.select(fts, {
		prompt = "Select which filetype to edit:",
	}, function(item, idx)
		-- selection aborted -> idx == nil
		if idx then
			vim.cmd("edit ~/.config/nvim/snippets/" .. item .. ".snippets")
		end
	end)
end

vim.cmd([[
command! LuaSnipEdit :lua _G.edit_ft('snippets')
command! LuaSnipEditLua :lua require("luasnip.loaders.from_lua").edit_snippet_files()
]])

-- add custom local snippets below here
