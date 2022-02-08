local M = {}

-- DEBUGGING: vim.lsp.set_log_level("debug")

local nvim_lsp = require('lspconfig')

-- completion capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
function M.is_floating_window_open()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win in pairs(wins) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= "" then
      return true
    end
  end
  return false
end

function M.open_diagnostic()
  local mode = vim.api.nvim_get_mode()
  local ok, lib = pcall(require, 'toggle_lsp_diagnostics')
  if ok and not lib.settings.all then
    return
  end
  if mode.mode ~= "n" or M.is_floating_window_open() then
    return
  end
  vim.diagnostic.open_float(nil, {focus=false})
end
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('user.lsp').open_diagnostic()]]
-- end diagnostic configuration


local border = {
  {"🭽", "FloatBorder"},
  {"▔", "FloatBorder"},
  {"🭾", "FloatBorder"},
  {"▕", "FloatBorder"},
  {"🭿", "FloatBorder"},
  {"▁", "FloatBorder"},
  {"🭼", "FloatBorder"},
  {"▏", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border}),
}


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Trouble lsp_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>Trouble lsp_type_definitions<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>Trouble lsp_implementations<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Trouble lsp_references<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>a', '<cmd>Trouble document_diagnostics<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>s', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)
end

-- Format command, autoformat
vim.cmd [[
command! -nargs=0 Format :lua vim.lsp.buf.formatting_sync({}, 3000)
autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync({}, 3000)
]]

-- LSP installer configuration
local lsp_installer = require("nvim-lsp-installer")

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities,
      on_attach = on_attach,
      handlers = handlers,
    }

    -- (optional) Customize the options passed to the server
    if server.name == "efm" then
      opts.init_options = { documentFormatting = true }
      opts.filetypes = { 'python', 'lua' }
      opts.settings = {
        rootMarkers = {".git/"},
        languages = {
          lua = {
            {formatCommand = "lua-format -i", formatStdin = true},
          },
          python = {
            {formatCommand = "black --quiet -", formatStdin = true},
          },
        },
      }
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
-- end LSP installer configuration

-- LSP status
require("fidget").setup{}

-- LSP signature help
require("lsp_signature").setup{}

-- Toggle diagnostics plugin
require("toggle_lsp_diagnostics").init{ virtual_text = false }

-- LSP diagnostics helpers
require("trouble").setup{
  -- if there's only one entry, automatically jump to it for these modes
  auto_jump = {"lsp_definitions", "lsp_implementations", "lsp_type_definitions"},
}

return M
