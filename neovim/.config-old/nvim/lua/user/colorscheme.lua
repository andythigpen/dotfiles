-- material.nvim theme

local contrast = {
    sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = true, -- Enable contrast for floating windows
    filetypes = { -- Specify which filetypes get the contrasted (darker) background
        "terminal",
        "floaterm",
        "qf", -- quickfix
        "fugitive",
        "tagbar",
        "nerdtree",
        "aerial",
        "vim-plug",
        "Trouble",
        "neotest-summary",
        "neo-tree-popup",
    },
}

local custom_highlights = {
    SignatureMarkText = { fg = "#3B3F51", bg = "#0F111A" },
    CursorLineNr = { fg = "#EEFFFF" },
    CursorLine = { bg = "#0F111A" },
    VertSplit = { fg = "#464B5D", bg = "#090B10" },
    TabLineSel = { bg = "#1F2233", fg = "#A6ACCD" },
    DiffAdd = { bg = "#283b4d" },
    DiffDelete = { fg = "#4d384d", bg = "#3c2c3c" },
    DiffChange = { bg = "#283b4d" },
    DiffText = { bg = "#365069" },
    Floaterm = { bg = "#090B10" },
    TermStatusDefault = { fg = "#A6ACCD" },
    TermStatusRunning = { fg = "#C792EA" },
    TermStatusFocused = { fg = "Orange" },
    helpHyperTextJump = { link = "Underlined" },
    WinSeparator = { link = "Whitespace" },
    VirtColumn = { fg = "#232637" },
    ColorColumn = { bg = "NONE" },
    NeoTreeNormal = { link = "NormalContrast" },
    NeoTreeSignColumn = { bg = "NONE" },
    NeoTreeNormalNC = { link = "NeoTreeNormal" },
    NeoTreeFloatNormal = { link = "NeoTreeNormal" },
    NeoTreeFloatBorder = { fg = "#444444", bg = "#090B10" },
    DiffviewNormal = { link = "NormalContrast" },
    Cursor = { bg = "NONE" },
    WinBarNormal = { fg = "#60667d", italic = true },
    FloatTitle = { link = "Normal" },
    TSNote = { fg = "#89ddff" },
    EnvieModeN = { fg = "#0F111A", bg = "#84FFFF" },
    EnvieModeV = { fg = "#0F111A", bg = "#C792EA" },
    EnvieModeI = { fg = "#0F111A", bg = "#C3E88D" },
    EnvieModeC = { fg = "#0F111A", bg = "#FFCB6B" },
    EnvieModeR = { fg = "#0F111A", bg = "#F07178" },
    EnvieModeT = { fg = "#0F111A", bg = "#F07178" },
    EnvieColorColumn = { fg = "#232637" },
}

if vim.env.NVIM_FILLED_BOXES or vim.g.envie_ui then
    contrast.floating_windows = false
    custom_highlights.NormalFloat = { bg = "#232637" }
    custom_highlights.TelescopeNormal = { bg = "#232637" }
    custom_highlights.TelescopeBorder = { fg = "#232637", bg = "#0F111A" }
    custom_highlights.TelescopeTitle = { fg = "#A6ACCD" }
end

local opts = {
    contrast = contrast,

    styles = {
        comments = { italic = true },
    },

    plugins = { -- Uncomment the plugins that you use to highlight them
        "dap",
        "nvim-cmp",
        "nvim-web-devicons",
        "telescope",
        "trouble",
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
}

-- if vim.g.envie_ui then
-- 	opts.high_visibility.darker = true
-- end

require("material").setup(opts)

vim.g.material_style = "deep ocean"

-- set cursorline
-- let g:material_style = 'deep ocean'
vim.cmd([[
  colorscheme material
]])
