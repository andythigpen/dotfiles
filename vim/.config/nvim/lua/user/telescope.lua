-- telescope settings

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")

local function clear_prompt()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-u>", true, true, true), "n", true)
end

local defaults = {
	path_display = { "smart" },
	mappings = {
		n = {
			["<C-k>"] = actions.move_selection_previous,
			["<C-j>"] = actions.move_selection_next,
			["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			["<C-a>"] = actions.select_all,
			["<C-b>"] = actions.results_scrolling_up,
			["<C-f>"] = actions.results_scrolling_down,
			["<PageUp>"] = actions.preview_scrolling_up,
			["<PageDown>"] = actions.preview_scrolling_down,
			["<C-t>"] = trouble.open_with_trouble,
		},
		i = {
			["<C-k>"] = actions.move_selection_previous,
			["<C-j>"] = actions.move_selection_next,
			["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			["<C-u>"] = clear_prompt,
			["<C-a>"] = actions.select_all,
			["<C-b>"] = actions.results_scrolling_up,
			["<C-f>"] = actions.results_scrolling_down,
			["<PageUp>"] = actions.preview_scrolling_up,
			["<PageDown>"] = actions.preview_scrolling_down,
			["<C-t>"] = trouble.open_with_trouble,
		},
	},
	sorting_strategy = "ascending",
	selection_strategy = "reset",
	layout_strategy = "horizontal",
	layout_config = {
		horizontal = {
			prompt_position = "top",
		},
		anchor = "S",
		width = function(_, max_columns, _)
			return max_columns - 14
		end,
		height = 30,
	},
	results_title = false,
	prompt_prefix = "  ",
	selection_caret = "▶  ",
	entry_prefix = "   ",
}

if vim.env.NVIM_FILLED_BOXES then
	defaults.borderchars = { "⠆", "⠄", "⠇", "⠅", "⠀", "⠁", "⠃", "⠂" }
end

-- Global remapping
------------------------
telescope.setup({
	defaults = defaults,
	pickers = {
		find_files = {
			-- theme = "ivy",
			results_title = false,
		},
		buffers = {
			results_title = false,
			mappings = {
				n = {
					["dd"] = actions.delete_buffer,
				},
			},
			-- sort_lastused = true,
			sort_mru = true,
			ignore_current_buffer = true,
		},
		grep_string = {
			path_display = { "shorten" },
			word_match = "-w",
			only_sort_text = true,
			search = "",
			results_title = false,
			layout_config = {
				anchor = "CENTER",
				height = 0.85,
			},
		},
		git_status = {
			initial_mode = "normal",
			attach_mappings = function(_, map)
				actions.select_default:replace(function(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection == nil then
						print("[telescope] Nothing currently selected")
						return
					end
					actions.close(prompt_bufnr)
					vim.fn.histadd("cmd", "Git difftool -y -- " .. selection.value)
					vim.cmd("Git difftool -y -- " .. selection.value)
				end)
				map("n", "cc", function(prompt_bufnr)
					actions.close(prompt_bufnr)
					vim.fn.histadd("cmd", "Git commit")
					vim.cmd("Git commit")
				end)
				map("n", "s", actions.git_staging_toggle)
				return true
			end,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

telescope.load_extension("fzf")

-- mappings
vim.cmd([[
nnoremap <silent><leader>b :Telescope buffers<CR>
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <C-g> :Telescope live_grep<CR>
]])
