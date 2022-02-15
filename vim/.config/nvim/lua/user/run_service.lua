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

function M.toggle()
  if not M.is_running() then
    return
  end
  vim.fn["floaterm#toggle"](0, 0, M.term_name)
end

function M.is_running()
  -- there's should be a better way to do this
  local existing = vim.fn["floaterm#cmdline#complete_names1"]()
  return vim.tbl_contains(existing, M.term_name)
end

function M.is_configured()
  local start_cmd = vim.fn['projectionist#query_exec']('start')
  return #start_cmd > 0
end

function M.run()
  -- returns a list of { project, cmd }
  local start_cmd = vim.fn['projectionist#query_exec']('start')

  if #start_cmd == 0 then
    vim.notify('No Start command configured')
    return
  end

  if M.is_running() then
    vim.fn["floaterm#show"](0, 0, M.term_name)
    return
  end

  -- just use the first one (most-specific)
  start_cmd = start_cmd[1]

  vim.fn["floaterm#new"](0, start_cmd[2], { cwd = start_cmd[1] }, {
    name = M.term_name,
    silent = true,
    autoclose = 0,
  })
end

return M
