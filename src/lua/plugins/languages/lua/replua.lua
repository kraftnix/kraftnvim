return {
  'replua.nvim',
  enabled = nixInfo(false, "settings", "languages", "lsp", "enable"),
  for_cat = "lua",
  after = function (...)
    require('replua').setup({
      print_prefix = "-- -> ",
      result_prefix = "-- => ",
      newline_after_result = true,
      persist_env = true,
    })
  end,
}
