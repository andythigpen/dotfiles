local M = {}

M.term_name = 'run_service'

-- Returns 2 if running, 1 if configured and not running, 0 otherwise
function M.status()
  if M.is_running() then
    return 2
  end
  if M.is_configured() then
    return 1
  end
  return 0
end

function M.toggle_if_running(name)
  name = name or M.term_name
  if not M.is_running(name) then
    return
  end
  M.toggle(name)
end

local function win_exists(winid)
  return vim.fn.empty(vim.fn.getwininfo(winid)) == 0
end

-- changes behavior I don't like in FloatermToggle
-- instead of focusing on the window when it's visible, this will hide it (i.e. actually toggle it)
function M.toggle(name, opts, cmd)
  cmd = cmd or ""
  opts = opts or {}
  opts["name"] = name

  local bufnr = vim.fn["floaterm#terminal#get_bufnr"](name)
  if bufnr == -1 then
    vim.fn["floaterm#new"](0, cmd, { [vim.type_idx] = vim.types.dictionary }, opts)
    return
  elseif bufnr == 0 then
    vim.fn["floaterm#toggle"](0, 0, name)
    return
  end
  local winid = vim.fn.getbufvar(bufnr, 'floaterm_winid', -1)
  if winid ~= -1 and win_exists(winid) then
    vim.fn["floaterm#window#hide"](bufnr)
    return
  end
  vim.fn["floaterm#toggle"](0, 0, name)
end

function M.is_running(name)
  name = name or M.term_name
  -- there's should be a better way to do this
  local existing = vim.fn["floaterm#cmdline#complete_names1"]()
  return vim.tbl_contains(existing, name)
end

function M.is_configured()
  local start_cmd = vim.fn['projectionist#query_exec']('start')
  return #start_cmd > 0
end

function M.run(name)
  name = name or M.term_name
  -- returns a list of { project, cmd }
  local start_cmd = vim.fn['projectionist#query_exec']('start')

  if #start_cmd == 0 then
    vim.notify('No Start command configured')
    return
  end

  if M.is_running() then
    vim.fn["floaterm#show"](0, 0, name)
    return
  end

  -- just use the first one (most-specific)
  start_cmd = start_cmd[1]

  vim.fn["floaterm#new"](0, start_cmd[2], { cwd = start_cmd[1] }, {
    name = name,
    silent = true,
    autoclose = 0,
  })
end

vim.cmd [[
let g:floaterm_wintype='split'
let g:floaterm_height=15
let g:floaterm_autoinsert=v:false
nnoremap <silent> <leader>` :lua require('user.terminal').toggle_if_running()<CR>
nnoremap <silent> <leader>1 :lua require('user.terminal').toggle('term1', { title = 'term1' })<CR>
nnoremap <silent> <leader>2 :lua require('user.terminal').toggle('term2', { title = 'term2' })<CR>
]]


return M
