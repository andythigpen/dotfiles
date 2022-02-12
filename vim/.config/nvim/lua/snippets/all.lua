local ls = require('luasnip')
local s = ls.snippet
local f = ls.function_node

local uuid = require('lib.uuid')
uuid.randomseed(os.time())

-- define global snippets
local snippets = {
  s("date", {f(function() return os.date("%Y-%m-%d") end)}),
  s("time", {f(function() return os.date("%I:%M:%S %p") end)}),
  s("ts", {f(function() return os.date("%Y-%m-%dT%H:%M:%S") end)}),
  s("uuid", {f(function() return uuid() end)}),
}

return snippets
