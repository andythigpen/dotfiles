return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" },
    event = "BufReadPost",
    keys = {
        { "zR", function() require('ufo').openAllFolds() end,  desc = "open all folds" },
        { "zM", function() require('ufo').closeAllFolds() end, desc = "close all folds" },
    },
    opts = {
        close_fold_kinds_for_ft = {
            default = {},
        },
    },
}
