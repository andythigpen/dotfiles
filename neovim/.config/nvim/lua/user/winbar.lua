-- modified from https://github.com/stevearc/aerial.nvim/discussions/106
local M = {}

local aerial = require("aerial")
local icons = require("nvim-web-devicons")

local excluded_filetypes = {
    "fidget",
    "TelescopePrompt",
    "TelescopeResults",
    "floaterm",
    "qf",
    "fugitive",
    "gitcommit",
    "neo-tree",
    "aerial",
    "Trouble",
    "neotest-summary",
    "startup",
    "DressingInput",
}


local function format_symbols(symbols, depth, separator, icons_enabled)
    local parts = {}
    depth = depth or #symbols

    if depth > 0 then
        symbols = { unpack(symbols, 1, depth) }
    else
        symbols = { unpack(symbols, #symbols + 1 + depth) }
    end

    for _, symbol in ipairs(symbols) do
        if icons_enabled then
            table.insert(
                parts,
                string.format("%%#Aerial%sIcon#%s%%#WinBarNormal# %s", symbol.kind, symbol.icon, symbol.name)
            )
        else
            table.insert(parts, symbol.name)
        end
    end

    return table.concat(parts, separator)
end

M.winbar = function()
    local separator = "  "
    local symbols = aerial.get_location(true)
    local symbol_path = format_symbols(symbols, nil, separator, true)

    local winbar = ""
    local icon, highlight = icons.get_icon_by_filetype(vim.bo.filetype)

    if vim.wo.number and vim.wo.numberwidth > 0 then
        winbar = string.rep(" ", vim.wo.numberwidth)
    end
    if icon then
        winbar = winbar .. "%#" .. highlight .. "#" .. icon .. " "
    end
    winbar = winbar .. "%#WinBarNormal#%f"
    if symbol_path ~= "" then
        winbar = winbar .. separator .. symbol_path
    end
    return winbar
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    callback = function()
        if vim.bo.filetype == "" or vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
            vim.opt_local.winbar = nil
            return
        end
        local winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value(
            "winbar",
            "%{%v:lua.require('user.winbar').winbar()%}",
            { scope = "local", win = winnr }
        )
    end,
})

return M
