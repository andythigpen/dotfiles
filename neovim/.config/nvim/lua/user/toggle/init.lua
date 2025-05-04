local M = {}

local default_toggles = {
    ["true"] = "false",
    ["True"] = "False",
    ["on"] = "off",
    ["enable"] = "disable",
    ["enabled"] = "disabled",
    ["yes"] = "no",
    ["left"] = "right",
    ["up"] = "down",
    ["!="] = "==",
    ["!=="] = "===",
    [">"] = "<",
    [">="] = "<=",
    ["[ ]"] = "[x]",
}

local toggles = {}

local function expand_word()
    local pos = vim.fn.getpos(".")
    local row = pos[2] - 1
    local cursor_col = pos[3] - 1
    local word = vim.fn.expand("<cword>")
    local line = vim.fn.getline(".")
    local idx = math.max(0, cursor_col - #word)
    local col = idx
    while idx < #line do
        col = idx
        if word == line:sub(idx, idx + #word - 1) then
            break
        end
        idx = idx + 1
    end
    return row, col - 1, word
end

local function find_markdown_checkbox()
    local node = vim.treesitter.get_node()
    if node == nil then
        return 0, 0, ""
    end
    while node ~= nil and node:type() ~= "list_item" do
        node = node:parent()
    end
    if node == nil then
        return 0, 0, ""
    end
    for child in node:iter_children() do
        if child:type() == "task_list_marker_unchecked" or child:type() == "task_list_marker_checked" then
            local row, col, _ = child:start()
            return row, col, vim.treesitter.get_node_text(child, 0)
        end
    end
    return 0, 0, ""
end

M.toggle = function()
    local start_row, start_col, text = expand_word()
    local inverse = toggles[text]
    if inverse == nil and vim.bo.filetype == "markdown" then
        start_row, start_col, text = find_markdown_checkbox()
        inverse = toggles[text]
    end
    if inverse == nil then
        return
    end
    vim.api.nvim_buf_set_text(0, start_row, start_col, start_row, start_col + #text, { inverse })
end

M.setup = function()
    toggles = {}
    for key, value in pairs(default_toggles) do
        toggles[key] = value
        toggles[value] = key
    end

    vim.api.nvim_create_user_command("InverseToggle", M.toggle, { desc = "Toggles the inverse text under the cursor" })
    vim.keymap.set("n", "<space>i", M.toggle, { desc = "Toggles the inverse text under the cursor" })
end

return M
