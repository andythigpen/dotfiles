local util = require("lspconfig.util")

local root_files = {
    "nx.json",
}
local fallback_root_files = {
    "package.json",
}

return {
    autostart = false,
    root_dir = function(fname)
        local primary = util.root_pattern(unpack(root_files))(fname)
        local fallback = util.root_pattern(unpack(fallback_root_files))(fname)
        return primary or fallback
    end,
    on_attach = function(client)
        -- disable document formatting in favor of using null-ls
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}
