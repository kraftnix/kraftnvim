local h = require('utils.helper')
return {

  -- search/replace in multiple files
  -- need to set up
  -- https://github.com/nvim-pack/nvim-spectre
  { "nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>rss", 'Spectre', desc = "Toggle Spectre (search)" },
      { "<leader>rss", h.lr('spectre', 'toggle'), desc = "Toggle Spectre (search)" },
      { "<leader>rsw", h.lr('spectre', 'open_visual', {select_work=true}), desc = "Search current word" },
      { "<leader>rsw", '<esc><cmd>lua require("spectre").open_visual()<cr>', desc = "Search current word (visual)", mode = 'v', is_nvim_command = true },
      { "<leader>rsf", h.lr('spectre', 'open_file_search', {select_work=true}), desc = "Search on current file" },
    },
    after = function ()
      require('spectre').setup({
        open_cmd = "noswapfile vnew",
        mapping = { }
      })
    end
  },


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
