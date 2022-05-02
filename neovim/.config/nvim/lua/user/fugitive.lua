-- TODO: convert this into lua
vim.cmd([[
function! GetBufferList()
  return filter(range(1,bufnr('$')), 'buflisted(v:val)')
endfunction

function! GetMatchingBuffers(pattern)
  return filter(GetBufferList(), 'bufname(v:val) =~ a:pattern')
endfunction

function! WipeMatchingBuffers(pattern)
  let l:matchlist = GetMatchingBuffers(a:pattern)

  let l:count = len(l:matchlist)
  if l:count < 1
    " echo 'No buffers found matching pattern ' . a:pattern
    return
  endif

  if l:count == 1
    let l:suffix = ''
  else
    let l:suffix = 's'
  endif

  exec 'bw ' . join(l:matchlist, ' ')
  " echo 'Wiped ' . l:count . ' buffer' . l:suffix . '.'
endfunction

command! Gdiffoff call WipeMatchingBuffers('fugitive://')

function! ToggleGStatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
    Gdiffoff
  else
    Git
    15wincmd_
  endif
endfunction
command! ToggleGStatus :call ToggleGStatus()
nnoremap <silent> <leader>g :ToggleGStatus<cr>

augroup fugitive_au
  autocmd!
  autocmd FileType fugitive setlocal winfixheight
augroup END
]])
