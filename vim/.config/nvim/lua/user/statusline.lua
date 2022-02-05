-- configuration for lualine

local lualine = require('lualine')

lualine.setup {
  extensions = {'fugitive', 'nerdtree', 'quickfix'},
  sections = { 
    lualine_a = {
      -- shorten the mode output to just the first character
      { 'mode', fmt = function(str) return str:sub(1,1) end },
    },
  },
}

-- the status line already shows the mode
vim.cmd[[set noshowmode]]
