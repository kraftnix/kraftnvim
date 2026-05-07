local M = { }

---NOTE: vendored from legendary
---      this is stupid, but functions are cached in lua so can't be renamed
---Return a function which lazily `require`s a module and
---calls a function from it. Functions nested within tables
---may be accessed using dot-notation, i.e.
---`lazy_required_fn('module_name', 'some.nested.fn', some_argument)`
---@param module_name string The module to `require`
---@param fn_name string The table path to the function
---@param ... any The arguments to pass to the function
---@return function
M.lr = function (module_name, fn_name, ...)
  local args = { ... }
  return require('utils.vendor.legendary').lazy_required_fn(module_name, fn_name, unpack(args))
end
M.legendary = require('utils.vendor.legendary')
M.lazy_required_fn = M.legendary.lazy_required_fn

---Follow ssh auth_sock
---@return string|nil
function M.get_ssh_auth_sock()
  local path = '~/.ssh/auth_sock'
  local ssh_auth_sock = vim.fn.system('readlink -f '..path)
  if not ssh_auth_sock then
    log.error('No SSH_AUTH_SOCK symlink found at '..path)
    return nil
  else
    ssh_auth_sock = ssh_auth_sock:gsub("[\n\r]", "")
    return "let $SSH_AUTH_SOCK = '"..ssh_auth_sock.."'"
  end
end

---Updates internal neovim SSH_AUTH_SOCK variable
function M.update_ssh_auth_sock()
  local cmd = M.get_ssh_auth_sock()
  if cmd then
    log.info('Updated SSH auth sock with cmd: ', cmd)
    vim.cmd(cmd)
  end
end

-- returns directory of current buffer file
M.GetCurrDir = function ()
  file = vim.fn.expand("%")
  if M.StrEmpty(file) then
    return vim.fn.getcwd()
  else
    return vim.fn.system("dirname "..file):gsub("%s+", "")
  end
end

--- Return true if string is empty or nil
---@param string string
---@return boolean
M.StrEmpty = function (string)
  return string == nil or string == ""
end

--- returns directory of current buffer file
---@param cmd string
M.FmDir = function (cmd)
  local parent = M.GetCurrDir()
  vim.cmd (string.format(":%s %s", cmd, parent))
end

-- transforms `project/name` -> `name`
M.NameFromRepo = function (repo)
  return repo:match('/(.-)$')
end

---Returns the current directory
---@return string|string[]
M.get_current_buf_dir = function()
  return vim.fn.expand('%:p:h')
end

---Returns file name from a path
---@param path string
---@return string file_name
M.get_file_name = function (path)
  local split_strings = vim.fn.split(path, "/")
  return split_strings[#split_strings]
end

return M
