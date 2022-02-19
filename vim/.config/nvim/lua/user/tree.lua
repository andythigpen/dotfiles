-- tree configuration

require("nvim-tree").setup({
	update_focused_file = {
		enable = true,
	},
	view = {
		width = 50,
		mappings = {
			list = {
				{
					key = "H",
					action = "go_to_top",
					action_cb = function()
						vim.cmd('execute "normal gg"')
					end,
				},
				{ key = "i", action = "toggle_dotfiles" },
				{ key = "x", action = "close_node" },
				{ key = "<C-x>", action = "cut" },
				{ key = "J", action = nil },
				{ key = "K", action = nil },
				{ key = ">", action = nil },
				{ key = "<", action = nil },
				{ key = "<C-j>", action = "next_sibling" },
				{ key = "<C-k>", action = "prev_sibling" },
				{ key = "C", action = "cd" },
				{ key = "u", action = "dir_up" },
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
})

-- key mappings
vim.cmd([[
nnoremap <silent><leader>f :NvimTreeToggle<CR>
]])
