nixInfo.lze.load("plugins.languages.nix")
nixInfo.lze.load("plugins.languages.lua")
nixInfo.lze.load("plugins.languages.java")
return {
  { import = 'plugins.languages.conform' },
  { import = 'plugins.languages.lspconfig' },
  { import = 'plugins.languages.treesitter' },
  { import = 'plugins.languages.treesitter-textobjects' },
}
