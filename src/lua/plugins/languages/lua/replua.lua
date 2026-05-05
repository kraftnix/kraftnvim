return {
  'replua.nvim',
  after = function (...)
    require('replua').setup({
      print_prefix = "-- -> ",
      result_prefix = "-- => ",
      newline_after_result = true,
      persist_env = true,
    })
  end,
}
