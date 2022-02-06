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
    "qf",                -- quickfix
    "fugitive",
    "tagbar",
    "nerdtree",
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
    -- CursorLine = { fg = '#0000FF', gui = 'underline' },
    -- LineNr = { bg = '#FF0000' }
  } -- Overwrite highlights with your own
}

vim.cmd [[
  let g:material_style = 'deep ocean'
  colorscheme material
]]
