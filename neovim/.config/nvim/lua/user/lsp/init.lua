local M = {}

-- DEBUGGING: vim.lsp.set_log_level("debug")

-- diagnostic configuration
vim.diagnostic.config({
    virtual_text = false,
})
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- automatically open diagnostic float on hover
M.is_floating_window_open = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win in pairs(wins) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative ~= "" then
            return true
        end
    end
    return false
end

M.open_diagnostic = function()
    local mode = vim.api.nvim_get_mode()
    local ok, lib = pcall(require, "toggle_lsp_diagnostics")
    if ok and not lib.settings.all then
        return
    end
    if mode.mode ~= "n" or M.is_floating_window_open() then
        return
    end
    vim.diagnostic.open_float(nil, { focus = false })
end
vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('user.lsp').open_diagnostic()]])
-- end diagnostic configuration

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local mapping_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", mapping_opts)
vim.api.nvim_set_keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", mapping_opts)
vim.api.nvim_set_keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", mapping_opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", mapping_opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
---@diagnostic disable-next-line: unused-local
M.on_attach = function(_client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gvD", "<cmd>rightbelow vsplit +lua\\ vim.lsp.buf.declaration()<CR>",
        mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gvd", "<cmd>rightbelow vsplit +lua\\ vim.lsp.buf.definition()<CR>",
        mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gvy", "<cmd>rightbelow vsplit +lua\\ vim.lsp.buf.type_definition()<CR>",
        mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gvi", "<cmd>rightbelow vsplit +lua\\ vim.lsp.buf.implementation()<CR>",
        mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<space>wa",
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        mapping_opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<space>wr",
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        mapping_opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<space>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        mapping_opts
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>a", "<cmd>Telescope diagnostics<CR>", mapping_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>s", "<cmd>Telescope lsp_workspace_symbols<CR>", mapping_opts)

    -- Add Format command, automatically format on save
    vim.cmd([[
command! -buffer -nargs=0 Format :lua vim.lsp.buf.format({ timeout_ms = 3000 })
autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 3000 })
  ]])
end

-- LSP configuration
local lspconfig = require("lspconfig")

M.configure_lsp = function(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }
    local opts = {
        on_attach = M.on_attach,
        capabilities = capabilities,
    }

    -- load LSP server-specific settings from separate modules
    local ok, server_opts = pcall(require, "user.lsp." .. server)
    if ok then
        -- merge the local options into the defaults
        for k, v in pairs(server_opts) do
            if k == "on_attach" then
                -- make sure the default on_attach is not overridden
                opts.on_attach = function(...)
                    M.on_attach(...)
                    server_opts.on_attach(...)
                end
            else
                opts[k] = v
            end
        end
    end

    lspconfig[server].setup(opts)
end

return M
