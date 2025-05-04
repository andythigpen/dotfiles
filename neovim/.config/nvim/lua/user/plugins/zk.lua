local groups = {
    { name = "default" },
    { name = "daily",   dir = "daily" },
    { name = "tickets", dir = "tickets" },
}

local function open_today_note()
    require("zk").new({ group = "daily", dir = "daily" })
end

local function pick_todos()
    require("telescope.builtin").grep_string({
        prompt_title = 'TODOs',
        use_regex = true,
        search = "(-|\\*) \\[( |-)\\]",
    })
end

local function standup()
    vim.cmd.tabnew()
    open_today_note()
    local width = math.min(50, vim.api.nvim_win_get_width(0))
    if width < 50 then
        width = 15
    end

    vim.cmd('belowright ' .. width .. 'vnew')
    vim.cmd([[silent lgrep! "(\\-\|\\*) \\[( \|\\-)\\]"]])
    local height = vim.api.nvim_win_get_height(0)
    height = math.max(10, height - 14)
    vim.cmd('lopen ' .. height)
    vim.cmd.wincmd('h')

    require("zk.api").list(nil, {
        select = { "path" },
        hrefs = { "daily" },
        sort = { "created" },
        createdBefore = "today",
        limit = 1,
    }, function(err, notes)
        if err ~= nil then
            return
        end
        if #notes == 0 then
            return
        end
        vim.cmd('belowright split ' .. notes[1].path)
        vim.cmd('wincmd p')
    end)
end


local function get_markdown_link_node()
    local node = vim.treesitter.get_node({ lang = "markdown_inline" })
    if node == nil then
        return
    end

    ---@param n TSNode
    local function get_link_text_node(n, line, col)
        if n:type() == "link_text" then
            if vim.treesitter.is_in_node_range(n, line, col) then
                return n
            end
            return
        elseif n:type() == "shortcut_link" then
            local child = n:child(1)
            if child ~= nil and vim.treesitter.is_in_node_range(child, line, col) then
                return child
            end
            return
        elseif n:type() == "inline" then
            for child in n:iter_children() do
                local r = get_link_text_node(child, line, col)
                if r ~= nil then
                    return r
                end
            end
        end
    end

    local pos = vim.fn.getpos(".")
    -- get_link_text_node expects 0-based so we subtract 1 from the row, but not from the column
    -- until after we advance past the initial square brackets since the node range does not include these
    local row = pos[2] - 1
    local col = pos[3]
    local line = vim.api.nvim_get_current_line()
    while true do
        local ch = line:sub(col, col)
        if ch ~= '[' then
            break
        end
        col = col + 1
    end
    return get_link_text_node(node, row, col - 1)
end

local function new_note()
    ---@param title? string
    ---@param group? {name:string, dir: string|nil}
    ---@param cb? fun(err, res)
    local function new_note_(title, group, cb)
        if title == nil then
            vim.ui.input({ prompt = "Title" }, function(input)
                if input == nil then
                    return
                end
                new_note_(input, group, cb)
            end)
            return
        end
        if group == nil then
            vim.ui.select(
                groups,
                {
                    prompt = "Select group:",
                    format_item = function(item)
                        return item.name
                    end
                }, function(item, idx)
                    if idx == nil then
                        return
                    end
                    new_note_(title, item, cb)
                end)
            return
        end
        local opts = { title = title }
        if group.name ~= "default" then
            opts.group = group.name
            opts.dir = group.dir
        end
        require("zk.api").new(nil, opts, cb)
    end

    local link_node = get_markdown_link_node()
    if link_node ~= nil then
        local text = vim.treesitter.get_node_text(link_node, 0)
        local parts = vim.split(text, "|", { trimempty = true })
        local title = parts[1]
        if #parts == 2 then
            title = parts[2]
        end
        local start_row, start_col, end_row, end_col = link_node:range()
        new_note_(title, nil, function(err, res)
            if err ~= nil then
                return
            end
            local name = vim.fn.fnamemodify(res.path, ":t:r")
            if name ~= title then
                vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { name .. "|" .. title })
            end
        end)
        return
    end

    new_note_()
end

return {
    "zk-org/zk-nvim",
    config = function()
        require("zk").setup({
            picker = "telescope",
            lsp = {
                config = {
                    cmd = { "zk", "lsp" },
                    name = "zk",
                    on_attach = require("user.lsp").on_attach,
                },
            },
        })

        vim.api.nvim_create_user_command("Today", open_today_note, {})
        vim.api.nvim_create_user_command("Standup", standup, {})
        vim.keymap.set("n", "<space>nt", pick_todos, {})
        vim.keymap.set("n", "<space>nn", new_note, {})
    end
}
