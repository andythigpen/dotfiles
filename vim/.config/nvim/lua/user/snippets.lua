
local function prequire(...)
local status, lib = pcall(require, ...)
if (status) then return lib end
    return nil
end

local ls = prequire('luasnip')

-- keymappings
vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-snippet", {})
vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-jump-next", {})
vim.api.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-jump-prev", {})

-- loads snippets (snipmate format) from directories named "snippets" in the runtimepath
require("luasnip.loaders.from_snipmate").load()

local uuid = require("lib.uuid")
uuid.randomseed(os.time())

-- lua snippets
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

ls.snippets = {
  all = {
    s("date", {f(function(args) return os.date("%Y-%m-%d") end)}),
    s("time", {f(function(args) return os.date("%I:%M:%S %p") end)}),
    s("ts", {f(function(args) return os.date("%Y-%m-%dT%H:%M:%S") end)}),
    s("uuid", {f(function(args) return uuid() end)}),
  },
}
