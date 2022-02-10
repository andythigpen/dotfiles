local ls = require('luasnip')

local M = {}

-- Registers snippets for a given filetype.
function M.register(filetype, snippets)
  local lang_snips = ls.snippets[filetype] or {}
  ls.snippets[filetype] = vim.list_extend(lang_snips, snippets)
end

return M
