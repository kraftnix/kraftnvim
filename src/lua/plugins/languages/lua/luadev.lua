return {
  'nvim-luadev',
  enabled = nixInfo(false, "settings", "languages", "lsp", "enable"),
  for_cat = "lua",
  cmd = 'Luadev',
  keys = {
    { '<leader>rl', '<cmd>Luadev<cr>',                       noremap = false, silent = false, mode = "v", desc = 'Open Luadev terminal' },
    { '<leader>rr', '<Plug>(Luadev-Run)',                    noremap = false, silent = false, mode = "v", desc = 'Execute the current line' },
    { '<leader>rr', '<Plug>(Luadev-RunLine)',                noremap = false, silent = false, mode = "n", desc = 'Operator to execute lua code over a movement or text object.' },
    { '<leader>rR', 'ggVG<bar><Plug>(Luadev-Run)<bar><c-o>', noremap = false, silent = true,  mode = "n", desc = 'Execute whole file' },
    { '<leader>rc', '<Plug>(Luadev-RunWord)',                noremap = false, silent = false, mode = "n", desc = 'Eval identifier under cursor, including `table.attr`' },
    { '<leader>rw', '<Plug>(Luadev-Complete)',               noremap = false, silent = false, mode = "n", desc = 'in insert mode: complete (nested) global table fields' },
  }
}
