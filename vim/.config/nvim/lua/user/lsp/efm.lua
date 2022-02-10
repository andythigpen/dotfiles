return {
  init_options = { documentFormatting = true },
  filetypes = { 'python', 'lua' },
  settings = {
    rootMarkers = {".git/"},
    languages = {
      lua = {
        {formatCommand = "lua-format -i", formatStdin = true},
      },
      python = {
        {formatCommand = "black --quiet -", formatStdin = true},
      },
    },
  },
}
