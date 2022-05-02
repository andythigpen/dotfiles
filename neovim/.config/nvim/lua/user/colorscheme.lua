-- material.nvim theme

local contrast = {
	sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
	floating_windows = true, -- Enable contrast for floating windows
	popup_menu = true, -- Enable lighter background for the popup menu
}

local custom_highlights = {
	SignatureMarkText = { fg = "#3B3F51", bg = "#0F111A" },
	CursorLineNr = { fg = "#EEFFFF" },
	CursorLine = { bg = "#0F111A" },
	VertSplit = { fg = "#464B5D", bg = "#090B10" },
	TabLineSel = { bg = "#1F2233", fg = "#A6ACCD" },
	DiffAdd = { bg = "#12261E" },
	DiffDelete = { bg = "#301A1F" },
	DiffChange = { bg = "#12261E" },
	DiffText = { bg = "#1D572C" },
	Floaterm = { bg = "#090B10" },
	TermStatusDefault = { fg = "#A6ACCD" },
	TermStatusRunning = { fg = "#C792EA" },
	TermStatusFocused = { fg = "Orange" },
	helpHyperTextJump = { link = "Underlined" },
	WinSeparator = { link = "Whitespace" },
	VirtColumn = { fg = "#232637" },
	ColorColumn = { bg = "NONE" },
}

if vim.env.NVIM_FILLED_BOXES then
	contrast.floating_windows = false
	custom_highlights.NormalFloat = { bg = "#232637" }
	custom_highlights.TelescopeNormal = { bg = "#232637" }
	custom_highlights.TelescopeBorder = { fg = "#232637", bg = "#0F111A" }
	custom_highlights.TelescopeTitle = { fg = "#A6ACCD" }
end

require("material").setup({
	contrast = contrast,

	italics = {
		comments = true, -- Enable italic comments
	},

	contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
		"terminal",
		"floaterm",
		"qf", -- quickfix
		"fugitive",
		"tagbar",
		"nerdtree",
		"UltestSummary",
		"aerial",
		"vim-plug",
		"Trouble",
	},

	high_visibility = {
		lighter = false, -- Enable higher contrast text for lighter style
		darker = true, -- Enable higher contrast text for darker style
	},

	disable = {
		eob_lines = true,
	},

	lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

	custom_highlights = custom_highlights,
})

vim.cmd([[
  set cursorline
  let g:material_style = 'deep ocean'
  colorscheme material
]])
