local h = KraftnixHelper
return {
  "ausgefuchster/quickselect.nvim",
  event = "VeryLazy",
  keycommands = {
    { "<c-s><c-n>", h.lr('quickselect', 'quick_select'), desc = "Quick select", modes = { "n", "x", "o" } },
    { "<c-s><c-y>", h.lr('quickselect', 'quick_yank'), desc = "Quick yank", modes = { "n", "x", "o" } },
  },
  opts = {
    patterns = {
      -- Hex color
      "#%x%x%x%x%x%x",
      -- Short-Hex color
      "#%x%x%x",
      -- RGB color
      "rgb(%d+,%d+,%d+)",
      -- IP Address
      "%d+%.%d+%.%d+%.%d+",
      -- Email
      "%w+@%w+%.%w+",
      -- URL
      "https?://[%w-_%.%?%.:/%+=&]+",
      -- 4+ digit number
      "%d%d%d%d+",
      -- File path
      "~/[%w-_%.%?%.:/%+=&]+",
      -- File path 2
      "[%.]+/[%w-_%.%?%.:/%+=&]+",
      -- File path 3
      "[%s]+/[%w-_%.%?%.:/%+=&]+",
      -- github flake URL
      "github:[%w-_%.%?%.:/%+=&]+",
      -- sha hash
      "sha256-[%w-_%.%?%.:/%+]+=",
    },
    select_match = true,
    use_default_patterns = true,
    labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    -- keymap = {
    --   {
    --     mode = { 'n' },
    --     '<leader>js',
    --     function()
    --       require('quickselect').quick_select()
    --     end,
    --     desc = 'Quick select'
    --   },
    --   {
    --     mode = { 'n' },
    --     '<leader>jy',
    --     function()
    --       require('quickselect').quick_yank()
    --     end,
    --     desc = 'Quick yank'
    --   }
    -- },
  },
}
