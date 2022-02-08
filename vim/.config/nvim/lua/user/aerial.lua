-- aerial outline view setup
require("aerial").setup{
  max_width = 50,
  min_width = 50,
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },
  close_on_select = true,
}

vim.cmd [[nnoremap <silent><leader>t :AerialToggle<CR>]]
