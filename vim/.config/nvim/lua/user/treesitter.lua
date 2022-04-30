-- treesitter configuration

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		disable = {},
	},
	indent = {
		enable = true,
		disable = { "ruby", "go", "python", "yaml" },
	},
	endwise = {
		enable = true,
	},
	ensure_installed = {
		"tsx",
		"toml",
		"json",
		"yaml",
		"html",
		"ruby",
		"python",
		"dockerfile",
		"css",
		"go",
		"gomod",
		"lua",
		"typescript",
		"rust",
		"cpp",
		"c",
		"bash",
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25,
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})

local file_types = require("nvim-treesitter.parsers").filetype_to_parsername
file_types.javascript = "tsx"
file_types["typescript.tsx"] = "tsx"

-- use treesitter for folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
