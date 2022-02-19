-- material.nvim theme
require('material').setup{
  contrast = {
    sidebars = true,          -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = true,  -- Enable contrast for floating windows
    popup_menu = true,        -- Enable lighter background for the popup menu
  },

  italics = {
    comments = true, -- Enable italic comments
  },

  contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
    "terminal",
    "floaterm",
    "qf",                -- quickfix
    "fugitive",
    "tagbar",
    "nerdtree",
    "UltestSummary",
    "aerial",
    "vim-plug",
    "Trouble",
  },

  high_visibility = {
    lighter = false,  -- Enable higher contrast text for lighter style
    darker = true     -- Enable higher contrast text for darker style
  },

  disable = {
    eob_lines = true,
  },

  lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

  custom_highlights = {
    SignatureMarkText = { fg = '#3B3F51', bg = '#0F111A' },
    CursorLineNr = { fg = '#EEFFFF' },
    CursorLine = { bg = '#0F111A' },
    VertSplit = { fg = '#090B10', bg = '#090B10' },
    TabLineSel = { bg = '#1F2233', fg = '#A6ACCD' },
    DiffAdd = { bg = '#12261E' },
    DiffDelete = { bg = '#301A1F' },
    DiffChange = { bg = '#12261E' },
    DiffText = { bg = '#1D572C' },
    Floaterm = { bg = '#090B10' },
  },
}

vim.cmd [[
  set cursorline
  let g:material_style = 'deep ocean'
  colorscheme material
]]


-- color column
require("virt-column").setup()
