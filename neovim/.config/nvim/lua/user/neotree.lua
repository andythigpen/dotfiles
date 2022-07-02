local keymap = vim.keymap.set

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
	enable_diagnostics = false,
	window = {
		mappings = {
			["x"] = "close_node",
			["o"] = "open",
			["<c-v>"] = "open_vsplit",
			["<c-x>"] = "cut_to_clipboard",
			["H"] = "none",
		},
	},
	event_handlers = {
		{
			event = "file_opened",
			handler = function(_path)
				--auto close
				require("neo-tree").close_all()
			end,
		},
	},
	filesystem = {
		bind_to_cwd = false,
		window = {
			mappings = {
				["C"] = "set_root",
				["i"] = "toggle_hidden",
				["u"] = "navigate_up",
			},
		},
	},
})

keymap("n", "<leader>f", ":Neotree toggle reveal_force_cwd<CR>", { silent = true })
