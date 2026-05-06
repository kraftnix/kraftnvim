local M = { }

local h = require('utils.helper')

---Returns a lazily called telescope picker
---Special handling for `find_file`, `live_grep` and `grep_string` to use menufacture
---@param command string telescope command
---@param opts {} any extra opts for the telescope builtin call
---@return function # lazily called telescope picker
function M.tb(command, opts)
  if command == 'find_files' or command == 'live_grep' or command == 'grep_string' then
    return h.lazy_required_fn('telescope', 'extensions.menufacture.'..command, opts)
  else
    return h.lazy_required_fn('telescope.builtin', command, opts)
  end
end

---## Lazy Telescope wrapper function
---Provides easy `path` searching with expansion and integrates `menufacture` automatically
---@param cmd string any telescope command, special handling for [find_files, live_grep, grep_string]
---@param path string vim path string to search in, is expanded by vim.fn.expand() i.e. `'%:p:h'` for current buffer dir
---@param extra? table any extra options to pass into telescope
---@return function telescope_picker_func # lazily wrapped telescope picker
function M.tb_wrap(cmd, path, extra)
  extra = extra or {}
  local inferred = {}
  -- nested function for path expansion
  return function ()
    if cmd == 'live_grep' then
      inferred.search_dirs = { vim.fn.expand(path) }
    end
    local opts = vim.tbl_extend('force', {
      layout_strategy = 'vertical',
      cwd = vim.fn.expand(path),
    }, inferred, extra)
    -- get lazy func and call it instantly
    return M.tb(cmd, opts)()
  end
end

-- returns a legendary keymap entry
M.set_telescope_command = function(mapping, command, opts)
  if type(command) == "string" then
    local last = "<cr>"
    if opts.is_nvim_command then
      last = ""
    end
    command = ":Telescope "..cmd..last
    -- cmd = function ()
    --   require('telescope.builtin')[vim.fn.copy(cmd)]()
    -- end
  elseif type(command) == "function" then
    -- vim.print(cmd)
  else
    assert(false, vim.print('Incorrect type given for opt end', command, opts))
  end
  local desc = ""
  if type(opts) == "string" then
    desc = opts
    opts = { }
  end
  -- opts[3] = 'n'
  opts.desc = desc
  opts.cmd = nil
  opts.f = nil
  if opts.is_nvim_command then
    opts.is_nvim_command = nil
  end
  vim.keymap.set('n', "<leader>"..mapping, command, opts)
end

-- returns a legendary keymap entry
M.make_telescope_command_legendary = function(opts)
  local mapping = opts[1] or opts.mapping
  local cmd = opts[2] or opts.f or opts.cmd
  if type(cmd) == "string" then
    local last = "<cr>"
    if opts.is_nvim_command then
      last = ""
    end
    cmd = ":Telescope "..cmd..last
    -- cmd = function ()
    --   require('telescope.builtin')[vim.fn.copy(cmd)]()
    -- end
  elseif type(cmd) == "function" then
    -- vim.print(cmd)
  else
    assert(false, vim.print('Incorrect type given for opt end', cmd, opts))
  end
  local desc = opts[3] or opts.desc or ""
  opts[1] = "<leader>"..mapping
  opts[2] = cmd
  -- opts[3] = 'n'
  opts.desc = desc
  opts.mode = 'n'
  opts[3] = nil
  opts.cmd = nil
  opts.f = nil
  if opts.is_nvim_command then
    opts.is_nvim_command = nil
    opts[1] = opts[2]
    opts[2] = nil
  end
  return opts
end

return M
