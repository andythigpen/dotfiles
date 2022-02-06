" load from vimrc for now until everything can be moved over
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" load lua configuration
lua require('user.startup')
lua require('user.material')
lua require('user.cmp')
lua require('user.lsp')
lua require('user.snippets')
lua require('user.treesitter')
lua require('user.statusline')
