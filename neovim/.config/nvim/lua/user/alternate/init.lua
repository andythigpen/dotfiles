local Menu = require("nui.menu")

local M = {}

local config = require("user.alternate.config")

---@class Alternate
---@field alternate string
---@field description string
---@field condition fun(filename: string) | nil
---@field excludes string|nil the first alternate that matches will exclude any others from being matched with the same value

---@class Pattern
---@field pattern string
---@field alternates Alternate[]

---@class Match
---@field filename string
---@field description string
---@field exists boolean


---@param filename string
---@return boolean
local function file_exists(filename)
    ---@diagnostic disable-next-line: param-type-mismatch
    return vim.fn.bufexists(filename) == 1 or vim.fn.filereadable(vim.fn.expand(filename)) == 1
end

---@param match Match
local function select_file(match)
    vim.cmd('e ' .. match.filename)
end

---@param match Match
local function vsplit_and_select_file(match)
    vim.cmd('rightbelow vsplit ' .. match.filename)
end

---@param alt any
---@return Alternate[]
local function build_alternates(alt)
    if type(alt) == "string" then
        return { { alternate = alt } }
    elseif type(alt) == "table" then
        if alt.alternate ~= nil then
            return { alt }
        else
            local alternates = {}
            for _, value in ipairs(alt) do
                for _, v in ipairs(build_alternates(value)) do
                    table.insert(alternates, v)
                end
            end
            return alternates
        end
    end
    return {}
end

---@param config_patterns any
---@return Pattern[]
local function build_patterns(config_patterns)
    ---@type Pattern[]
    local patterns = {}
    for p, alt in pairs(config_patterns) do
        ---@type Pattern
        local pattern = {
            pattern = p,
            alternates = build_alternates(alt),
        }
        table.insert(patterns, pattern)
    end
    return patterns
end

---@param matches Match[]
local function show_popup(matches, on_submit)
    local popup_options = {
        relative = "editor",
        position = {
            row = 3,
            col = "50%",
        },
        border = {
            padding = { 0, 1 },
            style = "rounded",
            text = {
                top = " Alternate ",
                top_align = "center",
            },
        },
        win_options = {
            cursorlineopt = "line",
            winhighlight = "CursorLine:PmenuSel",
        },
    }

    local left_pad = false
    for _, match in ipairs(matches) do
        if not match.exists then
            left_pad = true
        end
    end

    local items = {}
    for _, match in ipairs(matches) do
        local text = {}
        if not match.exists then
            text[#text + 1] = config.display_text.new
        elseif left_pad then
            text[#text + 1] = string.rep(" ", vim.fn.strwidth(config.display_text.new))
        end
        if match.description ~= nil then
            text[#text + 1] = "[" .. match.description .. "]"
            text[#text + 1] = " "
        end

        text[#text + 1] = match.filename
        table.insert(items, Menu.item(table.concat(text, ""), match))
    end

    local menu = Menu(popup_options, {
        lines = items,
        keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "q", "<Esc>", "<C-c>" },
            submit = { "<CR>", "<Space>" },
        },
        min_width = 60,
        on_submit = on_submit,
    })
    menu:mount()
    menu:on("BufLeave", function()
        menu:unmount()
    end, { once = true })
end

---@param pattern Pattern
---@param current_file string
---@param matches Match[]
local function find_alternates(pattern, current_file, matches)
    local captures = { string.match(current_file, pattern.pattern) }
    if #captures == 0 then
        return
    end
    local excludes = {}
    for _, alternate in ipairs(pattern.alternates) do
        if alternate.condition == nil or alternate.condition(current_file) then
            local m = alternate.alternate
            for i = 1, #captures do
                m = m:gsub("(%[" .. i .. "])", captures[i])
            end
            if not vim.tbl_contains(excludes, alternate.excludes) then
                ---@type Match
                local match = {
                    filename = m,
                    description = alternate.description,
                    exists = file_exists(m),
                }
                if alternate.excludes ~= nil then
                    if excludes[alternate.excludes] == nil then
                        excludes[alternate.excludes] = {}
                    end
                    table.insert(excludes[alternate.excludes], match)
                else
                    table.insert(matches, match)
                end
            end
        end
    end

    for _, exclude in pairs(excludes) do
        local matches_exist = vim.tbl_filter(function(value)
            return value.exists
        end, exclude)
        if #matches_exist > 0 then
            -- the first existing match wins
            table.insert(matches, matches_exist[1])
        else
            for _, match in ipairs(exclude) do
                table.insert(matches, match)
            end
        end
    end
end

local patterns = build_patterns(config.patterns)

---@return Match[]
local function find_matches()
    -- @see :h filename-modifiers
    local current_file = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
    ---@type Match[]
    local matches = {}
    for _, pattern in ipairs(patterns) do
        find_alternates(pattern, current_file, matches)
    end
    return matches
end

local function alternate(on_submit)
    local matches = find_matches()
    if #matches == 0 then
        return
    end
    if #matches == 1 and file_exists(matches[1].filename) then
        select_file(matches[1])
    else
        show_popup(matches, on_submit)
    end
end

M.add_patterns = function(config_patterns)
    local p = build_patterns(config_patterns)
    for _, pattern in ipairs(p) do
        table.insert(patterns, pattern)
    end
end

M.alternate = function()
    alternate(select_file)
end

M.alternate_vsplit = function()
    alternate(vsplit_and_select_file)
end

M.setup = function()
    vim.keymap.set("n", '<leader>a', M.alternate, { desc = "Open alternate file" })
    vim.keymap.set("n", '<leader>A', M.alternate_vsplit, { desc = "Open alternate file in vertical split" })
    vim.api.nvim_create_user_command('A', M.alternate, { desc = "Open alternate file" })
    vim.api.nvim_create_user_command('AV', M.alternate_vsplit, { desc = "Open alternate file in vertical split" })
end

return M
