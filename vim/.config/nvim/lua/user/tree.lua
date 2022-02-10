require('nvim-tree').setup{
  update_focused_file = {
    enable = true,
  },
  view = {
    width = 50,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
}

-- key mappings
vim.cmd[[
nnoremap <silent><leader>f :NvimTreeToggle<CR>
]]
