return {

  -- markdown previewer
  { 'render-markdown.nvim',
    cmd = "RenderMarkdown",
    keys = {
      { '<leader>am', ':RenderMarkdown toggle<CR>', desc = 'Toggle render-markdown plugin' },
    },
    after = function ()
      require('render-markdown').setup({
        completions = {
          lsp = { enabled = true },
        },
      })
    end
  },

}
