-- startup dashboard configuration

local M = {}

-- Runs git up and then displays a picker for the branches
function M.git_update()
  vim.call('FugitiveExecute', 'up')
  vim.cmd[[Telescope git_branches]]
end

local settings = {
  -- every line should be same width without escaped \
  header = {
    type = "text",
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "Header",
    margin = 5,
    content = {
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    },
    highlight = "Statement",
    default_color = "",
    oldfiles_amount = 0,
  },
  -- name which will be displayed and command
  body = {
    type = "mapping",
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "Basic Commands",
    margin = 5,
    content = {
      { " Recent Files", "Telescope oldfiles only_cwd=true", "r" },
      { " Find File", "Telescope find_files", "f" },
      { " Find Word", "Telescope live_grep", "g" },
      { " Git Branches", "lua require('user.startup').git_update()", "b" },
      { " New File", "enew", "n" },
      { " Quit", "q", "q" },
    },
    highlight = "String",
    default_color = "",
    oldfiles_amount = 0,
  },
  body_2 = {
    type = "oldfiles",
    oldfiles_directory = true,
    align = "center",
    fold_section = false,
    title = "Recent",
    margin = 5,
    content = "",
    highlight = "String",
    oldfiles_amount = 5,
  },
  footer = {
    type = "text",
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "Footer",
    margin = 5,
    content = function()
      return { os.date("%Y-%m-%d") }
    end,
    highlight = "Comment",
    default_color = "",
    oldfiles_amount = 0,
  },

  options = {
    after = function()
      require("startup.utils").oldfiles_mappings()
    end,
    mapping_keys = true,
    cursor_column = 0.5,
    empty_lines_between_mappings = true,
    disable_statuslines = true,
    paddings = { 1, 3, 3, 0 },
  },
  mappings = {
    execute_command = "<CR>",
    open_file = "o",
    open_file_split = "<c-o>",
    open_section = "<TAB>",
    open_help = "?",
  },
  colors = {
    background = "#1f2227",
    folded_section = "#56b6c2",
  },
  parts = { "header", "body", "body_2", "footer" },
}

require("startup").setup(settings)

return M
