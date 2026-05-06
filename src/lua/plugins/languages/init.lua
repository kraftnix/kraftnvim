return {
  { import = 'plugins.languages.nix' },
  { import = 'plugins.languages.lua' },
  { import = 'plugins.languages.java' },
  { import = 'plugins.languages.conform' },
  { import = 'plugins.languages.lspconfig' },
  { import = 'plugins.languages.treesitter' },
  { import = 'plugins.languages.treesitter-textobjects' },
  { "inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      { '<leader>rN<space>', ':IncRename<cr>', 'Incremntal Rename' }
    }
  },
}
