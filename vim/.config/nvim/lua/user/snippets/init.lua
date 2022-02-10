
require('luasnip.config').setup{
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  delete_check_events = 'TextChanged',
}

-- keymappings
vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-jump-prev", {})

-- loads snippets (snipmate format) from directories named "snippets" in the runtimepath
require("luasnip.loaders.from_snipmate").load()

-- load snippets defined in lua
require('user.snippets.all')



-- add custom local snippets below here
