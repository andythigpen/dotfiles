local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
-- local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- struct json field
    -- ex: FieldName string `json:"fieldName"`
    s("sj", fmt("{} {} `json:\"{}\"`", {
        i(1, "Field"),
        i(2, "string"),
        d(3, function(args)
            local field_name = string.lower(string.sub(args[1][1], 0, 1)) .. string.sub(args[1][1], 2)
            return sn(nil, i(1, field_name))
        end, { 1 }),
    })),
}
