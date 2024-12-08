require('nixCatsUtils').setup {
  non_nix_value = true,
}

local appname = os.getenv("NVIM_APPNAME")
-- we need to set configDirName in categories, only used here atm
if appname ~= "nvim" and appname ~= nixCats('configDirName') then
  print("Using non-standard appdir: "..appname..", running from: "..vim.fn.stdpath('config'))
end

-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = nixCats("have_nerd_font")

KraftnixUtils = require('kraftnix.utils.all')
KraftnixHelper = require('kraftnix.utils.helper')
MiddleClass = require('kraftnix.utils.vendor.middleclass')
require('kraftnix.config.options')

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require('nixCatsUtils').isNixCats and type(require('nixCats').settings.unwrappedCfgPath) == "string" then
    return require('nixCats').settings.unwrappedCfgPath .. "/lazy-lock.json"
  else
    return vim.fn.stdpath("config") .. "/lazy-lock.json"
  end
end
local lazyOptions = {
  lockfile = getlockfilepath(),
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}

-- NOTE: nixCats: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible({"allPlugins", "start", "lazy.nvim" }),
{
  { import = 'kraftnix.plugins' },
  { import = 'kraftnix.plugins.ui' },
  { import = 'kraftnix.plugins.keymaps' },
  { import = 'kraftnix.plugins.telescope' },
  { import = 'kraftnix.plugins.code' },
  { import = 'kraftnix.plugins.tools' },
  { import = 'kraftnix.plugins.movement' },
}, lazyOptions)

-------------------------------------------------------------------------------
-- experimenting with running from a local config dir without `wrapRc=false` --
-------------------------------------------------------------------------------
-- if nixCats('local') then
--   local customDirEnv = os.getenv("KRAFTNVIM_CONFIG_DIR")
--   local neovimDir = vim.fn.stdpath("config")
--   if customDirEnv ~= nil then
--     print("Overriding config dir with env variable KRAFTNVIM_CONFIG_DIR: " .. customDirEnv)
--     neovimDir = vim.fn.expand(customDirEnv)
--   end
--   local neovimInitLua = neovimDir .. "/init.lua"
--   print("Launching neovim from init: " .. neovimInitLua)
--   if vim.fn.filereadable(neovimInitLua) > 0 then
--       -- vim.opt.rtp:prepend(neovimDir)
--       -- vim.cmd("source " .. neovimInitLua)
--       dofile(neovimInitLua)
--   else
--       print("Error: init.lua file not found at " .. neovimInitLua)
--   end
-- else
--   ... rest of config ...
-- end
