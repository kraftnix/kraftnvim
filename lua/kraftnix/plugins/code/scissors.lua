local h = KraftnixHelper
return {
  'chrisgrieser/nvim-scissors',
  dir = "~/repos/chrisgrieser/nvim-scissors",
  keycommands_meta = {
    group_name = 'Scissors',
    description = 'Snippets generation + editing',
    icon = '✂',
    default_opts = { -- only applies to this lazy keygroup
      silent = true,
    }
  },
  keycommands = {
    -- this doesn't work in visual mode due to issue with keycommands / legendary
    -- { '<leader>sa', 'v$:ScissorsAddNewSnippet<cr>', "Add new snippet", nil, mode = { "x", "n", "v" }, is_nvim_command = true },
    { nil, 'v$:ScissorsAddNewSnippet<cr>', "Add new snippet", nil, mode = { "x", "n", "v" }, is_nvim_command = true },
    -- { '<leader>sa', 'V:ScissorsAddNewSnippet<cr>', "Add new snippet", nil, mode = "v", is_nvim_command = true },
    { '<leader>se', ':ScissorsEditSnippet', "Edit scissors snippets.", nil },
  },
	opts = {
    editSnippetPopup = {
      keymaps = {
        -- duplicateSnippet = "<C-w><C-c>",
        deleteSnippet = "<C-X>",
        -- openInFile = "<C-w><C-o>",
      },
    },
    -- this really doesn't work nicely with nix
    snippetDir = vim.fn.expand("$HOME/.config/nvim/lua/kraftnix/snippets"),
    jsonFormatter = "jq",
    telescope = {
      -- By default, the query only searches snippet prefixes. Set this to
      -- `true` to also search the body of the snippets.
      alsoSearchSnippetBody = true,

      -- accepts the common telescope picker config
      opts = {
        layout_strategy = "vertical",
        layout_config = {
          -- horizontal = { width = 0.9 },
          -- preview_width = 0.6,
        },
      },
    },
	},
  -- workaround for keycommands issue
  config = function(_, opts)
    require('scissors').setup(opts)
    vim.keymap.set({"n", "v", "x"}, '<leader>sa', 'v$:ScissorsAddNewSnippet<cr>', { noremap = true, silent = true, desc = 'Add new snippet' })
  end
}
