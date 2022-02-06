-- configuration for lualine

local lualine = require('lualine')

lualine.setup {
  extensions = {'fugitive', 'nerdtree', 'quickfix'},
  sections = { 
    lualine_a = {
      -- shorten the mode output to just the first character
      { 'mode', fmt = function(str) return str:sub(1,1) end },
    },
    lualine_x = {
      {'ultest', cond = function() return vim.call('ultest#is_test_file') == 1 end},
      'encoding',
      'fileformat',
      'filetype'
    },
  },
}

-- the status line already shows the mode
vim.cmd[[set noshowmode]]

return M
