--[[
--  I would prefer to just use mini.nvim since I prefer the look
--  however it doesn't support movement operators as well as
--  which-key like `v`, `i`, `a`, `]`
--
--  So to make them interoperable, some finessing is required
--]]

return {
  -- { 'echasnovski/mini.nvim',
  --   lazy = false,
  --   enabled = false;
  --   -- doesn't support visual modes with a/i, which-key does
  --   name = 'mini.clue',
  --   config = function ()
  --     local miniclue = require 'mini.clue'
  --     miniclue.setup({
  --       window = {
  --         delay = 0,
  --         config = {
  --           width = 'auto',
  --           border = 'double',
  --         },
  --       },
  --
  --       triggers = {
  --         -- Leader triggers
  --         { mode = 'n', keys = '<Leader>' },
  --         { mode = 'x', keys = '<Leader>' },
  --
  --         -- Built-in completion
  --         { mode = 'i', keys = '<C-x>' },
  --
  --         -- Substitution completion
  --         { mode = 'n', keys = '<C-S>' },
  --         { mode = 'i', keys = '<C-S>' },
  --
  --         -- `g` key
  --         { mode = 'n', keys = 'g' },
  --         { mode = 'x', keys = 'g' },
  --
  --         -- Movements
  --         { mode = 'n', keys = '[' },
  --         { mode = 'x', keys = '[' },
  --         { mode = 'n', keys = ']' },
  --         { mode = 'x', keys = ']' },
  --
  --         -- misses many mappings
  --         -- { mode = 'n', keys = 'a' },
  --         -- { mode = 'x', keys = 'a' },
  --         -- { mode = 'n', keys = 'i' },
  --         -- { mode = 'x', keys = 'i' },
  --
  --         -- Marks
  --         { mode = 'n', keys = "'" },
  --         { mode = 'n', keys = '`' },
  --         { mode = 'x', keys = "'" },
  --         { mode = 'x', keys = '`' },
  --
  --         -- Registers
  --         { mode = 'n', keys = '"' },
  --         { mode = 'x', keys = '"' },
  --         { mode = 'i', keys = '<C-r>' },
  --         { mode = 'c', keys = '<C-r>' },
  --
  --         -- Window commands
  --         { mode = 'n', keys = '<C-w>' },
  --
  --         -- `z` key
  --         { mode = 'n', keys = 'z' },
  --         { mode = 'x', keys = 'z' },
  --
  --         -- -- in/around
  --         -- { mode = 'x', keys = "i" },
  --         -- { mode = 'x', keys = 'a' },
  --       },
  --
  --       clues = {
  --         -- Enhance this by adding descriptions for <Leader> mapping groups
  --         miniclue.gen_clues.builtin_completion(),
  --         miniclue.gen_clues.g(),
  --         miniclue.gen_clues.marks(),
  --         miniclue.gen_clues.registers(),
  --         miniclue.gen_clues.windows(),
  --         miniclue.gen_clues.z(),
  --
  --         -- my own custom groups
  --         -- { keys = '<leader>a', desc = "[a] leftover operations (file managers, etc.)", mode = 'n' },
  --         { keys = '<leader>f', desc = "[f] telescope operations", mode = 'n' },
  --         { keys = '<leader>g', desc = "[g] git operations", mode = 'n' },
  --         { keys = '<leader>gd', desc = "[d]iff operations", mode = 'n' },
  --         { keys = '<leader>gp', desc = "[p]ull/[p]ush operations" },
  --         { keys = '<leader>f', desc = "[f] telescope operations", mode = 'n' },
  --         -- { keys = '<leader>q', desc = "[a]: misc operations (file managers, etc.)", mode = 'n' },
  --         { keys = '<leader>r', desc = "[r]eload operations", mode = 'n' },
  --         { keys = '<leader>s', desc = "[s]nippet operations", mode = 'n' },
  --         { keys = '<leader>t', desc = "[t]erminal operations", mode = 'n' },
  --         { keys = '<leader>w', desc = "[w]indow management operations", mode = 'n' },
  --         { keys = '<leader>fn', desc = "[n]ix operations", mode = 'n' },
  --
  --         -- `<C-x>` trigger.
  --         { mode = 'i', keys = '<C-x><C-f>', desc = 'File names' },
  --         { mode = 'i', keys = '<C-x><C-l>', desc = 'Whole lines' },
  --         { mode = 'i', keys = '<C-x><C-o>', desc = 'Omni completion' },
  --         { mode = 'i', keys = '<C-x><C-s>', desc = 'Spelling suggestions' },
  --         { mode = 'i', keys = '<C-x><C-u>', desc = "With 'completefunc'" },
  --         --
  --         -- special move submode
  --         { mode = 'n', keys = '<leader>mh', postkeys = '<leader>m' },
  --         { mode = 'n', keys = '<leader>mj', postkeys = '<leader>m' },
  --         { mode = 'n', keys = '<leader>mk', postkeys = '<leader>m' },
  --         { mode = 'n', keys = '<leader>ml', postkeys = '<leader>m' },
  --         { mode = 'x', keys = '<leader>mh', postkeys = '<leader>m' },
  --         { mode = 'x', keys = '<leader>mj', postkeys = '<leader>m' },
  --         { mode = 'x', keys = '<leader>mk', postkeys = '<leader>m' },
  --         { mode = 'x', keys = '<leader>ml', postkeys = '<leader>m' },
  --       },
  --
  --     })
  --   end
  -- },

  -- -- -- old which-key configurations
  -- { 'folke/which-key.nvim',
  --   dependencies = { 'mrjones2014/legendary.nvim' },
  --   event = "VeryLazy",
  --   -- lazy = false,
  --   -- enabled = false,
  --   init = function()
  --     vim.o.timeout = true
  --     -- vim.o.timeoutlen = 300
  --     vim.o.timeoutlen = 0
  --   end,
  --   opts = {
  --     -- add operators that will trigger motion and text object completion
  --     -- to enable all native operators, set the preset / operators plugin above
  --     operators = { gc = "Comments" },
  --     key_labels = {
  --       -- override the label used to display some keys. It doesn't effect WK in any other way.
  --       -- For example:
  --       -- ["<space>"] = "SPC",
  --       -- ["<cr>"] = "RET",
  --       -- ["<tab>"] = "TAB",
  --     },
  --     motions = {
  --       count = true,
  --     },
  --     icons = {
  --       breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
  --       separator = "➜", -- symbol used between a key and it's label
  --       group = "+", -- symbol prepended to a group
  --     },
  --     popup_mappings = {
  --       scroll_down = "<c-d>", -- binding to scroll down inside the popup
  --       scroll_up = "<c-u>", -- binding to scroll up inside the popup
  --     },
  --     window = {
  --       border = "none", -- none, single, double, shadow
  --       position = "bottom", -- bottom, top
  --       margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
  --       padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
  --       winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
  --       zindex = 1000, -- positive value to position WhichKey above other floating windows.
  --     },
  --     layout = {
  --       height = { min = 4, max = 25 }, -- min and max height of the columns
  --       width = { min = 20, max = 50 }, -- min and max width of the columns
  --       spacing = 3, -- spacing between columns
  --       align = "left", -- align columns left, center or right
  --     },
  --     ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  --     hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
  --     show_help = true, -- show a help message in the command line for using WhichKey
  --     show_keys = true, -- show the currently pressed key and its label as a message in the command line
  --     triggers = "auto", -- automatically setup triggers
  --     -- triggers = {"<leader>"} -- or specifiy a list manually
  --     -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
  --     triggers_nowait = {
  --       -- marks
  --       "`",
  --       "'",
  --       "g`",
  --       "g'",
  --       -- registers
  --       '"',
  --       "<c-r>",
  --       -- spelling
  --       "z=",
  --     },
  --     triggers_blacklist = {
  --       -- list of mode / prefixes that should never be hooked by WhichKey
  --       -- this is mostly relevant for keymaps that start with a native binding
  --       i = { "j", "k" },
  --       v = { "j", "k" },
  --     },
  --     -- disable the WhichKey popup for certain buf types and file types.
  --     -- Disabled by default for Telescope
  --     disable = {
  --       buftypes = {},
  --       filetypes = {},
  --     },
  --   },
  --   config = function(_, opts)
  --     local wk = require "which-key"
  --     wk.setup(opts)
  --     wk.register({
  --       ["<leader>"] = {
  --         a = { name = "[a] leftover operations (file managers, etc.)" },
  --         f = { name = "[f] telescope operations" },
  --         g = {
  --           name = "[g]it operations",
  --           d = { name = "[d]iff operations" },
  --           p = { name = "[p]ull/[p]ush operations" },
  --         },
  --         q = { name = "[a]: misc operations (file managers, etc.)" },
  --         r = { name = "[r]eload operations" },
  --         s = { name = "[s]nippet operations" },
  --         t = { name = "[t]erminal operations" },
  --         w = { name = "[w]indow management operations" },
  --       },
  --     })
  --   end,
  -- },

  -- -- minimal read-only which-key
  -- { 'folke/which-key.nvim',
  --   dependencies = { 'mrjones2014/legendary.nvim' },
  --   lazy = false,
  --   priorit = 10000,
  --   cmd = 'WhichKey',
  --   keys = {
  --     { '<M-->', ':WhichKey<cr>', desc = 'Open WhichKey', noremap = true }
  --   },
  --   -- event = "VeryLazy",
  --   -- enabled = false,
  --   opts = {
  --     plugins = {
  --       marks = false,
  --       registers = false,
  --       spelling = { enabled = false },
  --       presets = {
  --         operators = true, -- adds help for operators like d, y, ...
  --         motions = true, -- adds help for motions
  --         text_objects = true, -- help for text objects triggered after entering an operator
  --         windows = false, -- default bindings on <c-w>
  --         nav = false, -- misc bindings to work with windows
  --         z = false, -- bindings for folds, spelling and others prefixed with z
  --         g = false, -- bindings for prefixed with g
  --       },
  --     },
  --     -- add operators that will trigger motion and text object completion
  --     -- to enable all native operators, set the preset / operators plugin above
  --     operators = { gc = "Comments" },
  --     motions = { count = true, },
  --     icons = {
  --       breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
  --       separator = "➜", -- symbol used between a key and it's label
  --       group = "+", -- symbol prepended to a group
  --     },
  --     popup_mappings = {
  --       scroll_down = "<c-d>", -- binding to scroll down inside the popup
  --       scroll_up = "<c-u>", -- binding to scroll up inside the popup
  --     },
  --     window = {
  --       border = "none", -- none, single, double, shadow
  --       position = "top", -- bottom, top
  --       margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
  --       padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
  --       winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
  --       zindex = 1000, -- positive value to position WhichKey above other floating windows.
  --     },
  --     layout = {
  --       height = { min = 4, max = 25 }, -- min and max height of the columns
  --       width = { min = 20, max = 50 }, -- min and max width of the columns
  --       spacing = 3, -- spacing between columns
  --       align = "right", -- align columns left, center or right
  --     },
  --     ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  --     hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
  --     show_help = true, -- show a help message in the command line for using WhichKey
  --     show_keys = true, -- show the currently pressed key and its label as a message in the command line
  --     -- triggers = "auto", -- automatically setup triggers
  --     triggers = { "gc" },
  --     -- triggers = {"<leader>"} -- or specifiy a list manually
  --     -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
  --     triggers_blacklist = {
  --       -- list of mode / prefixes that should never be hooked by WhichKey
  --       -- this is mostly relevant for keymaps that start with a native binding
  --       i = { "j", "k" },
  --       v = { "j", "k" },
  --     },
  --     -- disable the WhichKey popup for certain buf types and file types.
  --     -- Disabled by default for Telescope
  --     disable = {
  --       buftypes = {},
  --       filetypes = {},
  --     },
  --   },
  -- }
}
