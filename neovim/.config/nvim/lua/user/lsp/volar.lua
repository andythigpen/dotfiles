return {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
    on_attach = function(client)
        -- disable document formatting in favor of using null-ls
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}
