-- tree configuration

local M = {}

local nvim_tree = require("nvim-tree")
local view = require("nvim-tree.view")

nvim_tree.setup({
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	update_cwd = false,
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

-- Fix behavior in NvimTreeFindFileToggle
-- I don't know why but it doesn't correctly focus the file when opening the window.
function M.toggle()
	if view.is_visible() then
		view.close()
	else
		nvim_tree.find_file(true)
	end
end

-- key mappings
vim.cmd([[
nnoremap <silent><leader>f :lua require('user.tree').toggle()<CR>
]])

return M
