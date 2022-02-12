" load from vimrc for now until everything can be moved over
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" load lua configuration
lua require('user')

lua <<EOF
function _G.ReloadConfig()
  for name, _ in pairs(package.loaded) do
    if name:match('^user') then
      package.loaded[name] = nil
    end
  end
  require('user')
end
EOF

command! ReloadConfig lua ReloadConfig()
