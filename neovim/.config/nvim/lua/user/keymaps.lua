local keymap = vim.keymap.set

-- toggle spell check (:h spell)
keymap("n", "<leader>sp", function()
    vim.wo.spell = not vim.wo.spell
end)

-- easier navigation between windows
keymap("n", "<C-J>", "<C-W><C-J>")
keymap("n", "<C-K>", "<C-W><C-K>")
keymap("n", "<C-L>", "<C-W><C-L>")
keymap("n", "<C-H>", "<C-W><C-H>")

-- insert new lines and stay in normal mode
keymap("n", "zj", "o<Esc>", { silent = true })
keymap("n", "zk", "O<Esc>", { silent = true })

-- clear the highlighting for the last search
keymap("n", "<leader>h", ":nohlsearch<CR>", { silent = true })
-- automatically prepend very-magic search mode to all searches
keymap("n", "/", "/\\v")

-- switch between last opened buffer
keymap("n", "<leader><BS>", "<C-^>", { silent = true })

-- quickfix mappings

-- returns true if the quickfix window is open, false otherwise
local function is_quickfix_open()
    for i = 1, vim.fn.winnr("$") do
        if vim.fn.getbufvar(vim.fn.winbufnr(i), "&buftype") == "quickfix" then
            return true
        end
    end
    return false
end

-- if the quickfix window is open, navigate in the direction given (one of next or previous).
-- returns a function intended to be used in a mapping
local function navigate_list(type, direction)
    if type ~= "c" and type ~= "l" then
        error("expected one of c or l for type")
    end
    if direction ~= "next" and direction ~= "previous" then
        error("expected one of next or previous for direction")
    end
    return function()
        pcall(function() vim.cmd({ cmd = type .. direction }) end)
    end
end

-- opens the quickfix window or closes it and returns to the previous window if it's currently open
local function toggle_quickfix()
    if is_quickfix_open() then
        vim.cmd("cclose")
        if vim.g.quickfix_return_to_window then
            vim.cmd(vim.g.quickfix_return_to_window .. "wincmd w")
        end
    else
        vim.g.quickfix_return_to_window = vim.fn.winnr()
        vim.cmd([[
      "Copen! -- requires dispatch
      copen
    ]])
    end
end

keymap("n", "<leader>q", toggle_quickfix, { silent = true })
keymap("n", "[q", navigate_list("c", "previous"), { silent = true })
keymap("n", "]q", navigate_list("c", "next"), { silent = true })
keymap("n", "[w", navigate_list("l", "previous"), { silent = true })
keymap("n", "]w", navigate_list("l", "next"), { silent = true })

-- toggle line numbers
local function toggle_columns()
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt_local.number:get() then
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.signcolumn = "no"
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    else
        vim.opt_local.foldcolumn = "1"
        vim.opt_local.signcolumn = "yes"
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    end
end
keymap("n", "<leader>n", toggle_columns, { silent = true })

-- terminal
keymap("t", "<Esc>", "<C-\\><C-n>")

-- remove indent with shift tab in insert mode
keymap("i", "<S-tab>", "<C-d>")
