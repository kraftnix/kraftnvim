local h = KraftnixHelper
return {
  'l3mon4d3/luasnip',
  dependencies = {
    'benfowler/telescope-luasnip.nvim',
    'rafamadriz/friendly-snippets'
  },
  keycommands_meta = {
    group_name = 'Luasnip',
    description = 'Snippets generation + editing',
    icon = '🖇️',
    default_opts = { -- only applies to this lazy keygroup
      silent = true,
    }
  },
  keycommands = {
    { '<leader>slf', 'Telescope luasnip', "Luasnip [S]nippets." },
    { '<leader>sle', h.lr("luasnip.loaders", 'edit_snippet_files'), "Edit LuaSnip Snippets." },
    { '<leader>sls', h.lr("luasnip", 'log.open'), "Open LuaSnip log" },
    { '<leader>slp', h.lr("luasnip", 'log.ping'), "Ping LuaSnip log to check it is working." },
    { '<leader>slr', h.lr("luasnip.loaders.from_lua", 'load', {paths = "./lua/kraftnix/snippets"}), "Reload local lua snippets" },
  },
  opts = {},
  config = function (_, opts)
    require('luasnip').setup(opts)
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_lua').lazy_load({ paths = "./lua/kraftnix/snippets" })
    -- allow loading from current dir
    -- require("luasnip.loaders.from_lua").load({paths = {vim.fn.getcwd() .. "/.luasnippets/"}})

    require('telescope').load_extension "luasnip"
  end
}
