local util = require("lspconfig.util")

local root_files = {
    "nx.json",
}
local fallback_root_files = {
    "package.json",
}

return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        root_dir = function(fname)
            local primary = util.root_pattern(unpack(root_files))(fname)
            local fallback = util.root_pattern(unpack(fallback_root_files))(fname)
            return primary or fallback
        end,
        on_attach = function(client, bufnr)
            require('user.lsp').on_attach(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
            tsserver_max_memory = 3072,
        },
    },
}
