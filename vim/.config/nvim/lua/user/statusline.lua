-- configuration for lualine

local lualine = require('lualine')

local function mode_format(str)
  local mode = str:sub(1,1)
  if vim.api.nvim_get_option('paste') then
    mode = mode .. " (PASTE)"
  end
  return mode
end

lualine.setup {
  extensions = {'fugitive', 'nerdtree', 'quickfix'},
  sections = {
    lualine_a = {
      -- shorten the mode output to just the first character
      { 'mode', fmt = mode_format },
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
