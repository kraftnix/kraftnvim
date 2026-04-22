-- Highlight, edit, and navigate code
local h = KraftnixHelper
local nixplugdir = require('kraftnix.utils.lazy_nix').nixplugdir
local user = vim.fn.getenv("USER")


return {

  { 'nvim-treesitter/nvim-treesitter',
    lazy = false,
    config = function(plugin)
      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return false
        end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        -- ensure folds are open to begin with
        vim.o.foldlevel = 99

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        return true
      end

      local installable_parsers = require("nvim-treesitter").get_available()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          if not treesitter_try_attach(buf,language) then
            if vim.tbl_contains(installable_parsers, language) then
              -- not already installed, so try to install them via nvim-treesitter if possible
              require("nvim-treesitter").install(language):await(function()
                treesitter_try_attach(buf, language)
              end)
            end
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function(plugin)
      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#using-a-package-manager
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function(plugin)
      require("nvim-treesitter-textobjects").setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
        move = {
          -- whether to set jumps in the jumplist
          set_jumps = true,
        },
      }

      -- SELECT
      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ "x", "o" }, "am", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "im", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
      end)

      -- SWAP
      vim.keymap.set("n", "<leader>ma", function()
        require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
      end)
      vim.keymap.set("n", "<leader>mp", function()
        require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
      end)


      -- MOVE
      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end)
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ "n", "x", "o" }, "]o", function()
        require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ "n", "x", "o" }, "]s", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "][", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[M", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
      end)

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ "n", "x", "o" }, "]d", function()
        require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[d", function()
        require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
      end)

      local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      -- Incremental Select
      vim.keymap.set({ 'x', 'o', 'n' }, '<BS>', function()
        require 'vim.treesitter._select'.select_child(vim.v.count1)
      end, { desc = 'Select child node' })

      vim.keymap.set({ 'x' , 'o', 'n'}, '<CR>', function()
        require 'vim.treesitter._select'.select_parent(vim.v.count1)
      end, { desc = 'Select parent node' })

    end,
  },

  -- NOTE(nvim-treesitter): master branch config
  -- causes compilation of treesitter with using lazy
  -- nix package doesn't work with lazy
  -- { 'nvim-treesitter/nvim-treesitter',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter-context',
  --     -- 'nvim-treesitter/nvim-treesitter-refactor',
  --     'nvim-treesitter/nvim-treesitter-textobjects',
  --     -- 'RRethy/nvim-treesitter-textsubjects',
  --   },
  --   config = function ()
  --
  --     -- vim.opt.rtp:prepend(nixplugdir .. "nvim-treesitter")
  --     -- vim.opt.rtp:prepend("/home/"..user.."/.config/nvim/parsers")
  --
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('nvim-treesitter.configs').setup {
  --       -- cannot be used when using nixpkgs nvim-treesitter
  --       -- Add languages to be installed here that you want installed for treesitter
  --       -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'nix' },
  --
  --       -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  --       auto_install = false,
  --
  --       -- parser_install_dir = nixplugdir .. "nvim-treesitter-parsers",
  --       -- parser_install_dir = "/home/"..user.."/.config/nvim/parsers",
  --
  --       highlight = { enable = true, },
  --       rainbow = { enable = true, },
  --       autotag = { enable = true, },
  --       indent = { enable = true, }, -- behaviours weirdly on nix
  --       incremental_selection = {
  --         enable = true,
  --         keymaps = {
  --           -- init_selection = "gnn",
  --           -- node_incremental = "grn",
  --           -- scope_incremental = "grc",
  --           -- node_decremental = "grm",
  --           init_selection = '<c-space>',
  --           node_incremental = '<c-space>',
  --           scope_incremental = '<c-s>',
  --           node_decremental = '<M-space>',
  --         },
  --       },
  --       query_linter = {
  --         enable = true,
  --         use_virtual_text = true,
  --         lint_events = { "BufWrite", "CursorHold" },
  --       },
  --       textobjects = {
  --         select = {
  --           enable = true,
  --           lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
  --           keymaps = {
  --             -- You can use the capture groups defined in textobjects.scm
  --             ['aa'] = '@parameter.outer',
  --             ['ia'] = '@parameter.inner',
  --             ['af'] = '@function.outer',
  --             ['if'] = '@function.inner',
  --             ['ac'] = '@class.outer',
  --             ['ic'] = '@class.inner',
  --           },
  --         },
  --         move = {
  --           enable = true,
  --           set_jumps = true, -- whether to set jumps in the jumplist
  --           goto_next_start = {
  --             [']r'] = '@parameter.inner',
  --             [']m'] = '@function.outer',
  --             [']]'] = '@class.outer',
  --             ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
  --             ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
  --           },
  --           goto_next_end = {
  --             [']R'] = '@parameter.inner',
  --             [']M'] = '@function.outer',
  --             [']['] = '@class.outer',
  --             ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
  --             ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
  --           },
  --           goto_previous_start = {
  --             ['[r'] = '@parameter.inner',
  --             ['[m'] = '@function.outer',
  --             ['[['] = '@class.outer',
  --             ["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
  --             ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
  --           },
  --           goto_previous_end = {
  --             ['[R'] = '@parameter.inner',
  --             ['[M'] = '@function.outer',
  --             ['[]'] = '@class.outer',
  --             ["[S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
  --             ["[Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
  --           },
  --         },
  --         lsp_interop = {
  --           enable = true,
  --           border = 'none',
  --           floating_preview_opts = {},
  --           peek_definition_code = {
  --             ["<leader>df"] = "@function.outer",
  --             ["<leader>dF"] = "@class.outer",
  --           },
  --         },
  --         swap = {
  --           enable = true,
  --           swap_next = {
  --             ['<leader>mn'] = '@parameter.inner',
  --           },
  --           swap_previous = {
  --             ['<leader>mp'] = '@parameter.inner',
  --           },
  --         },
  --       },
  --       textsubjects = {
  --           enable = true,
  --           prev_selection = ',', -- (Optional) keymap to select the previous selection
  --           keymaps = {
  --               ['.'] = 'textsubjects-smart',
  --               [';'] = 'textsubjects-container-outer',
  --               ['i;'] = 'textsubjects-container-inner',
  --           },
  --       },
  --       refactor = {
  --         highlight_definitions = {
  --           enable = true,
  --           clear_on_cursor_move = true,
  --         },
  --         highlight_current_scope = true,
  --         smart_rename = {
  --           enable = true,
  --           -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
  --           keymaps = {
  --             smart_rename = "<leader>rNt",
  --           },
  --         },
  --       },
  --       navigation = {
  --         enable = true,
  --         -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
  --         keymaps = {
  --           goto_definition = "gnd",
  --           list_definitions = "gnD",
  --           list_definitions_toc = "gO",
  --           goto_next_usage = "<a-*>",
  --           goto_previous_usage = "<a-#>",
  --         },
  --       },
  --     }
  --     -- vim.treesitter.language.add('nu', { path = vim.fn.stdpath("config") .. "/parser/nu.so" })
  --     -- vim.filetype.add({ extension = { nu = "nu" } })
  --   end
  -- }
  -- { 'nvim-treesitter/nvim-treesitter-context',
  --   opts = {
  --     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  --     max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
  --     min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  --     line_numbers = true,
  --     multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  --     trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  --     -- mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  --     mode = 'topline',
  --     -- Separator between context and content. Should be a single character string, like '-'.
  --     -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  --     separator = nil,
  --     zindex = 20, -- The Z-index of the context window
  --     on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  --   }
  -- },

  -- { 'JoosepAlviste/nvim-ts-context-commentstring',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' }
  -- },
}
