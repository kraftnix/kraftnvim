-- NOTE: Welcome to your neovim configuration!
-- The first 100ish lines are setup,
-- the rest is usage of lze and various core plugins!
vim.loader.enable() -- <- bytecode caching
do
  -- Set up a global in a way that also handles non-nix compat
  local ok
  ok, _G.nixInfo = pcall(require, vim.g.nix_info_plugin_name)
  if not ok then
    package.loaded[vim.g.nix_info_plugin_name] = setmetatable({}, {
      __call = function (_, default) return default end
    })
    _G.nixInfo = require(vim.g.nix_info_plugin_name)
    -- If you always use the fetcher function to fetch nix values,
    -- rather than indexing into the tables directly,
    -- it will use the value you specified as the default
    -- TODO: for non-nix compat, vim.pack.add in another file and require here.
  end
  nixInfo.isNix = vim.g.nix_info_plugin_name ~= nil
  ---@module 'lzextras'
  ---@type lzextras | lze
  nixInfo.lze = setmetatable(require('lze'), getmetatable(require('lzextras')))
  function nixInfo.get_nix_plugin_path(name)
    return nixInfo(nil, "plugins", "lazy", name) or nixInfo(nil, "plugins", "start", name)
  end
end
nixInfo.lze.register_handlers {
  {
    -- adds an `auto_enable` field to lze specs
    -- if true, will disable it if not installed by nix.
    -- if string, will disable if that name was not installed by nix.
    -- if a table of strings, it will disable if any were not.
    spec_field = "auto_enable",
    set_lazy = false,
    modify = function(plugin)
      if vim.g.nix_info_plugin_name then
        if type(plugin.auto_enable) == "table" then
          for _, name in pairs(plugin.auto_enable) do
            if not nixInfo.get_nix_plugin_path(name) then
              plugin.enabled = false
              break
            end
          end
        elseif type(plugin.auto_enable) == "string" then
          if not nixInfo.get_nix_plugin_path(plugin.auto_enable) then
            plugin.enabled = false
          end
        elseif type(plugin.auto_enable) == "boolean" and plugin.auto_enable then
          if not nixInfo.get_nix_plugin_path(plugin.name) then
            plugin.enabled = false
          end
        end
      end
      return plugin
    end,
  },
  {
    -- we made an options.settings.cats with the value of enable for our top level specs
    -- give for_cat = "name" to disable if that one is not enabled
    spec_field = "for_cat",
    set_lazy = false,
    modify = function(plugin)
      if vim.g.nix_info_plugin_name then
        if type(plugin.for_cat) == "string" then
          plugin.enabled = nixInfo(false, "settings", "cats", plugin.for_cat)
        end
      end
      return plugin
    end,
  },
  -- From lzextras. This one makes it so that
  -- you can set up lsps within lze specs,
  -- and trigger lspconfig setup hooks only on the correct filetypes
  -- It is (unfortunately) important that it be registered after the above 2,
  -- as it also relies on the modify hook, and the value of enabled at that point
  nixInfo.lze.lsp,
}

-- NOTE: This config uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- Because we have the paths, we can set a more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- If you do provide a filetype, this will never be called.
nixInfo.lze.h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixInfo.get_nix_plugin_path "nvim-lspconfig"
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    return (ok and cfg or {}).filetypes or {}
  else
    -- the less performant thing we are trying to avoid at startup
    return (vim.lsp.config[name] or {}).filetypes or {}
  end
end)

-- NOTE: These 2 should be set up before any plugins with keybinds are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('general')
require('keymaps')
require('autocmds')

-- nixInfo.lze.load("plugins.search.snacks")

-- NOTE: You will likely want to break this up into more files.
-- You can call this more than once.
-- You can also include other files from within the specs via an `import` spec.
-- see https://github.com/BirdeeHub/lze?tab=readme-ov-file#structuring-your-plugins
nixInfo.lze.load {
  {
    -- lze specs need a name
    "trigger_colorscheme",
    -- lazy loaded colorscheme.
    -- This means you will need to add the colorscheme you want to lze sometime before VimEnter is done
    event = "VimEnter",
    -- Also, lze can load more than just plugins.
    -- The default load field contains vim.cmd.packadd
    -- Here we override it to schedule when our colorscheme is loaded
    load = function(_name)
      -- schedule so it runs after VimEnter
      vim.schedule(function()
        vim.cmd.colorscheme(nixInfo("tokyonight-night", "settings", "colorscheme"))
        vim.schedule(function()
          -- I like this color. Use vim.schedule again to set it after the colorscheme is finished
          vim.cmd([[hi LineNr guifg=#bb9af7]])
        end)
      end)
    end
  },
  { import = "plugins.snacks" },
  { import = "plugins.ui" },
  { import = "plugins.which-key" },
  { import = "plugins.telescope" },
  { import = "plugins.git" },
  { import = "plugins.gitlinker" },
  { import = "plugins.clipboard" },
  { import = "plugins.file-manager" },
  { import = "plugins.mini" },
  { import = "plugins.misc" },
  { import = "plugins.flash" },
  { import = "plugins.docs" },
  { import = "plugins.harpoon" },
  { import = "plugins.dap" },
  { import = "plugins.snippets" },

  -- {
  --   "nvim-lint",
  --   auto_enable = true,
  --   -- cmd = { "" },
  --   event = "FileType",
  --   -- ft = "",
  --   -- keys = "",
  --   -- colorscheme = "",
  --   after = function (plugin)
  --     require('lint').linters_by_ft = {
  --       -- NOTE: download some linters
  --       -- and configure them here
  --       -- markdown = {'vale',},
  --       -- javascript = { 'eslint' },
  --       -- typescript = { 'eslint' },
  --     }
  --
  --     vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  --       callback = function()
  --         require("lint").try_lint()
  --       end,
  --     })
  --   end,
  -- },

  {
    "nvim-surround",
    auto_enable = true,
    event = "DeferredUIEnter",
    -- keys = "",
    after = function(plugin)
      require('nvim-surround').setup()
    end,
  },
  {
    "vim-startuptime",
    auto_enable = true,
    cmd = { "StartupTime" },
    before = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixInfo(vim.v.progpath, "progpath")
    end,
  },
  {
    "fidget.nvim",
    auto_enable = true,
    event = "DeferredUIEnter",
    -- keys = "",
    after = function(plugin)
      require('fidget').setup({})
    end,
  },
}

nixInfo.lze.load("plugins.languages")
nixInfo.lze.load("plugins.completion")
