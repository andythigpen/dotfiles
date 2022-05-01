local keymap = vim.keymap.set

-- aerial outline view setup
require("aerial").setup({
	max_width = 50,
	min_width = 50,
	default_direction = "right",
	filter_kind = {
		"Class",
		"Constructor",
		"Enum",
		"Function",
		"Interface",
		"Module",
		"Method",
		"Struct",
	},
	close_on_select = true,
})

keymap("n", "<leader>t", ":AerialToggle<CR>", { silent = true })
