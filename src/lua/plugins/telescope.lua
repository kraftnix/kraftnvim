local h = require('utils.helper')
local th = require('utils.telescope')
local defaults = require('utils.telescope.defaults')
local enabled = nixInfo(false, 'settings', 'telescope', 'enable')
local fullDependencies = {}
local fullKeys = {}
local profile = nixInfo('minimal', 'settings', 'telescope', 'profile')
if profile == 'full' then
  fullDependencies = {
    { 'telescope-cheat.nvim' },
    { 'telescope-env.nvim' },
    { 'telescope-file-browser.nvim' },
    { 'telescope-manix' },
    { 'telescope-project.nvim' },
    { 'telescope-tabs' },
    { 'telescope-undo.nvim' },
    { 'telescope-zoxide' },
  }
  fullKeys = {
    -- Extra
    { '<leader>f-', ':Telescope file_browser<CR>', desc = '[f-] Telescope File Browser' }, --dunno how to use
    { '<leader>fE', ':Telescope env<CR>', desc = '[f]ind [E]nvironment Variables (ENV)' }, --notwork
    { '<leader>fZ', ':Telescope cheat<CR>', desc = '[fz] find cheatsheets' }, --notwork
    { '<leader>fz', ':Telescope zoxide list<CR>', desc = '[f]ind [z]oxide links' }, --nice
    { '<leader>fp', ':Telescope project display_type=full<CR>', desc = '[f]ind [p]rojects' }, --nice
    { '<leader>fu', ':Telescope undo<CR>', desc = '[f]ind [u]ndo tree' }, --hmm
  }
end

return vim.list_extend(fullDependencies, {
  { 'telescope-fzf-native.nvim' },
  { 'telescope-live-grep-args.nvim' },
  { 'telescope-menufacture' },
  { 'telescope-luasnip.nvim', enabled = nixInfo(false, 'settings', 'snippets', 'enable'), },

  { 'telescope.nvim',
    -- enabled = nixInfo(false, 'settings', 'telescope', 'enable'),
    for_cat = 'telescope',
    cmd = 'Telescope',
    event = "DeferredUIEnter",
    keys = vim.list_extend(fullKeys, {
      -- Telescope Main
      { '<leader><space>', ':Legendary<CR>', desc = '[ ] Open Legendary' },
      { '<leader><C-space>', ':Telescope commander<CR>', desc = '[ ] Open commander' },
      { '<leader>f<space>', ':Telescope<CR>', desc = '[f]ind [T]elescope all builtins/extensions' },--gd but low prio
      { '<leader>st', ':Telescope<CR>', desc = '[f]ind [T]elescope all builtins/extensions' },--gd but low prio
      { '<leader>?', ':Telescope oldfiles<CR>', desc = '[?] Find recently opened files' },
      { '<leader>f:', ':Telescope commands<CR>', desc = '[f:] Telescope Command Picker' },--useful
      { '<leader>f;', ':Telescope command_history<CR>', desc = '[f;] Command History' }, --gd-ish


      -- Neovim related
      { '<leader>fvh', ':Telescope help_tags<CR>', desc = 'Neovim manpages search' },--essential
      { '<leader>fvH', ':Telescope highlights<CR>', desc = 'Neovim highlights search' },
      { '<leader>fvl', ':Telescope lazy<CR>', desc = '[f]ind [l]azy installed plugins' }, --nice
      { '<leader>fvk', ':Telescope keymaps<CR>', desc = '[f]ind mapped [k]ey bindings' },--gd
      { '<leader>fvo', ':Telescope vim_options<CR>', desc = 'find (neo)vim options' },
      { '<leader>fvj', ':Telescope jumplist<CR>', desc = 'find vim jumplist' },

      -- Telescope Ops
      { '<leader>fr', ':Telescope resume<CR>', desc = '[f]ind [r]esume (last command)' },--gd
      { '<leader>ft', h.lr('telescope-tabs', 'list_tabs'), desc = '[f]ind [t]abs' },--gd

      -- menufacture
      { '<leader>ff', h.lr('telescope', 'extensions.menufacture.find_files'), desc = '[f]ind [f]iles in whole project' },
      { '<leader>fg', h.lr('telescope', 'extensions.menufacture.live_grep'), desc = '[fg] fuzzy search whole project' },
      { '<leader>fw', h.lr('telescope', 'extensions.menufacture.grep_string'), desc = '[f]uzzy search [w]ord under your cursor' },

      -- Code / File Search
      { '<leader>fe', ':Telescope diagnostics<CR>', desc = '[f]ind [e]rrors / diagnostics' },
      { '<leader>fq', ':Telescope quickfix<CR>', desc = '[f]ind [q]uickfix list' },
      { '<leader>fQ', ':Telescope quickfixhistory<CR>', desc = '[f]ind [Q]uickfix history' },
      { '<leader>fl', th.tb('live_grep', { grep_open_files=true }), desc = '[f] Fuzzy search in a[l]l open buffers' },
      { '<leader>f~', th.tb('find_files', { search_dirs={'~'} }), desc = '[f~] Fuzzy search in home directory' },
      { '<leader>f.', th.tb_wrap('find_files', '%:p:h'), desc = '[f.] Fuzzy search in current directory' },
      { '<leader>fJ',
        function ()
          local dir = h.get_current_buf_dir()
          th.tb('live_grep', {search_dirs = { dir }, cwd = dir })()
        end,
        desc = '[fJ] Fuzzy search in current directory'
      },
      { '<leader>fj',
        function ()
          th.tb('current_buffer_fuzzy_find', h.lr('telescope.themes', 'get_dropdown', {
            winblend = 20,
            previewer = false,
          })())
        end,
        desc = '[fj] Fuzzily search in current buffer'
      },

      -- Nix
      -- map('n', '<leader>fn', function ()
      --   telescope_manix.search{ cword = true }
      -- end , { desc = 'Ma[n]ix Search for selected word' })
      -- map('n', '<leader>fN', function ()
      --   telescope_manix.search{ cword = false }
      -- end, { desc = '[N] Manix Search (global)' })

      -- Project
      -- -- vim.keymap.set('n', '<leader>fp', builtin.project, { desc = 'Search projects' })
    }),

    after = function ()
      local opts = {
        defaults = {
          -- history = {
          --   path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
          --   limit = 100,
          -- },
          winblend = 0,
          preview = { treesitter = true },
          vimgrep_arguments = defaults.vimgrep_core,
          sorting_strategy = "descending",
          layout_strategy = 'vertical',
          layout_config = {
            height = 0.95,
            preview_cutoff = 1,
          },
          previewer = true,
        },

        -- show hidden files
        pickers = {
          find_files = defaults.find_files,
          buffers = defaults.buffers,
        },

        --- extensions configuration
        extensions = {
          menufacture = {
            vimgrep_arguments = defaults.vimgrep_core,
            pickers = {
              find_files = defaults.find_files,
              buffers = defaults.buffers,
            },
            mappings = {
              main_menu = { [{ 'i', 'n' }] = '<C-f><C-f>' },
            },
          },
          project = {
            base_dirs = {
              '~/config',
              '~/repos',
              '~/work',
              '~/notes',
            },
          },
        },
      }

      local telescope = require 'telescope'
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      opts = vim.tbl_deep_extend ('force', opts or {}, {
        defaults = {
          mappings = {
            i = vim.tbl_extend('force', defaults.keymaps(), {
              ["<c-f><c-p>"] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
                local entry = action_state.get_selected_entry()
                vim.print('Picker', current_picker)
                vim.print('Entry', entry)
              end,
              -- Lazy reload plugin
              ["<c-f><c-r>"] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
                local entry = action_state.get_selected_entry()
                local plugin_name = entry.name
                local plugin = require("lazy.core.config").plugins[plugin_name]
                require("lazy.core.loader").reload(plugin)
                vim.print('Reloaded '..plugin_name..'.')
              end,
              -- ["<esc>"] = actions.close,
            }),
            n = vim.tbl_extend('force', defaults.keymaps(), {
              ["<esc>"] = actions.close,
            }),
          },
        },

        extensions = {
          zoxide = {
            prompt_title = "[ Walking on the shoulders of TJ ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print("Update to (" .. selection.z_score .. ") " .. selection.path)
                end
              },
              ["<C-f><C-f>"] = {
                before_action = function(selection) print("before C-f") end,
                action = function(selection)
                  vim.cmd.edit(selection.path)
                end
              },
              -- -- Opens the selected entry in a new split
              -- ["<C-q>"] = {
              --   action = z_utils.create_basic_command("split"),
              -- },
            },
          },
          bookmarks = { selected_browser = "firefox" },
        },
      })

      -- flash in telescope
      if nixInfo(false, 'info', 'flash', 'enable') then
        local function flash(prompt_bufnr)
          require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
              mode = "search",
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                end,
              },
            },
            action = function(match)
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              picker:set_selection(match.pos[1] - 1)
            end,
          })
        end
        opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
          mappings = {
            n = { s = flash },
            i = { ["<c-s>"] = flash },
          },
        })
      end


      telescope.setup(opts)

      if profile == 'full' then
        telescope.load_extension "cheat"
        telescope.load_extension "env"
        telescope.load_extension "file_browser"
        telescope.load_extension "manix"
        telescope.load_extension "undo"
      end
      telescope.load_extension "live_grep_args"
      telescope.load_extension 'menufacture'
      if nixInfo(false, 'settings', 'snippets', 'enable') then
        telescope.load_extension 'luasnip'
      end
      -- telescope.load_extension "smart_history" -- better defaults
      -- Enable telescope fzf native, if installed
      pcall(telescope.load_extension, 'fzf')
    end,

  },

  { 'easypick.nvim',
    enabled = profile == 'full',
    for_cat = 'telescope',
    cmd = 'Easypick',
    on_plugin = { 'telescope.nvim' },
    keys = {
      { '<leader>lae', ':Easypick<cr>', desc = "list [a]ll [e]asypickers", mode = { 'n' }, noremap = false, silent = false }
    },
    after = function ()
      local easypick = require("easypick")

      -- only required for the example to work
      local base_branch = "develop"

      -- a list of commands that you want to pick from
      local list = [[
      << EOF
      :Telescope live_grep
      :Telescope find_files
      :Git blame
      EOF
      ]]

      easypick.setup({
        pickers = {
          {
            name = "secrets",
            command = "ls secrets",
            previewer = easypick.previewers.default(),
            action = easypick.actions.nvim_commandf("tabe secrets/%s"),
          },

          {
            name = "hosts",
            command = "ls hosts",
            previewer = easypick.previewers.default(),
            action = easypick.actions.nvim_commandf("tabe hosts/%s"),
          },

          {
            name = "command_palette",
            command = "cat " .. list,
                              -- pass a pre-configured action that runs the command
            action = easypick.actions.nvim_commandf("%s"),
                              -- you can specify any theme you want, but the dropdown looks good for this example =)
            opts = require('telescope.themes').get_dropdown({})
          },

          -- diff current branch with base_branch and show files that changed with respective diffs in preview
          {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff({base_branch = base_branch})
          },

          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff()
          },
        }
      })
    end
  },


  --- search firefox bookmarks from neovim
  { 'browser_bookmarks.nvim',
    enabled = enabled and nixInfo(false, 'settings', 'telescope', 'bookmarks'),
    -- on_plugin = { 'telescope.nvim' },
    keys = {
      { '<leader>fb', ':Telescope bookmarks<CR>', desc = '[f]ind [b]ookmarks in from your browser' }, --cool
    },
    after = function ()
      -- require('browser-bookmarks').setup({
      --   selected_browser = 'firefox'
      -- })
    end
  },
})

-- requires nix plugin, sqlite.lua must be installed via nix
-- {
--   'prochri/telescope-all-recent.nvim',
--   dependencies = {
--     NixPlugin('kkharji/sqlite.lua'),
--   },
--   opts = {
--     database = {
--       folder = vim.fn.stdpath("data"),
--       file = "telescope-all-recent.sqlite3",
--       max_timestamps = 10,
--     },
--     scoring = {
--       recency_modifier = { -- also see telescope-frecency for these settings
--         [1] = { age = 240, value = 100 }, -- past 4 hours
--         [2] = { age = 1440, value = 80 }, -- past day
--         [3] = { age = 4320, value = 60 }, -- past 3 days
--         [4] = { age = 10080, value = 40 }, -- past week
--         [5] = { age = 43200, value = 20 }, -- past month
--         [6] = { age = 129600, value = 10 } -- past 90 days
--       },
--       -- how much the score of a recent item will be improved.
--       boost_factor = 0.0001
--     },
--     default = {
--       disable = true, -- disable any unkown pickers (recommended)
--       use_cwd = true, -- differentiate scoring for each picker based on cwd
--       sorting = 'recent' -- sorting: options: 'recent' and 'frecency'
--     },
--   },
-- },
