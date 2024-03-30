return {
    on_attach = function(client)
        -- force enable the LSP formatter because the server incorrectly responds with the capabilities as 'false'
        -- @see https://github.com/redhat-developer/yaml-language-server/issues/486
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
    end,
}
