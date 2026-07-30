function GitCurrentBranchName()
  local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d 'n'")
  if branch ~= "" then
    return branch
  else
    return ""
  end
end

local gitEnabled = nixInfo(false, 'settings', 'git', 'enable') and vim.fn.executable("git") == 1
return {

  --- not as nice as the in built quickfix list + next hunk jumping
  { "telescope-gitsigns",
    enabled = nixInfo(false, 'settings', 'telescope', 'enable') and gitEnabled,
    keys = {
      { '<leader>ggf', ":Telescope git_signs<CR>", desc = '[gg]it [f]ind signs' },
    },
    after = function ()
      require'telescope'.load_extension 'git_signs'
    end
  },

  --- add signs in left column based on git status
  { 'gitsigns.nvim',
    enabled = gitEnabled,
    event = "DeferredUIEnter",
    after = function ()
      require('gitsigns').setup({
        -- See `:help gitsigns.txt`
        numhl = true,
        linehl = false, -- disable line highlights by default due to conflicts with other highlights
        -- word_diff = true,
        preview_config = {
          border = "rounded"
        },
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']g', bang = true})
            else
              gs.nav_hunk('next')
            end
          end, { expr = true, desc = 'Jump to next hunk' })

          map({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({']g', bang = true})
            else
              gs.nav_hunk('prev')
            end
          end, { expr = true, desc = 'Jump to previous hunk' })

          -- Actions
          -- visual mode
          map('v', '<leader>ggs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = '[gg]it [s]tage hunk' })
          map('v', '<leader>ggrh', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = '[gg]it [r]eset [h]unk' })
          -- normal mode
          map('n', '<leader>ggs', gs.stage_hunk, { desc = '[gg]it [s]tage hunk (visual)' })
          map('n', '<leader>ggu', gs.undo_stage_hunk, { desc = '[gg]it [u]nstage hunk' })
          map('n', '<leader>ggrh', gs.reset_hunk, { desc = '[gg]it [r]eset [h]unk (visual)' })
          map('n', '<leader>ggS', gs.stage_buffer, { desc = '[gg]it [S]tage whole buffer' })
          -- map('n', '<leader>ggU', gs.undo_stage_buffer, { desc = '[gg]it [U]nstage whole buffer' })
          map('n', '<leader>ggrb', gs.reset_buffer_index, { desc = "[gg]it [r]eset [b]uffer, doesn't undo stages" })
          map('n', '<leader>ggrB', gs.reset_buffer, { desc = '[gg]it [r]eset [B]uffer (all hunks)' })
          map('n', '<leader>ggp', gs.preview_hunk, { desc = '[gg]it [p]review hunk' })
          map('n', '<leader>ggri', gs.reset_base, { desc = '[gg]it [r]eset base [i]ndex for diffs' })
          map('n', '<leader>ggb', function()
            gs.blame_line { full = false }
          end, { desc = '[gg]it toggle [b]lame line' })
          map('n', '<leader>ggq', gs.setqflist, { desc = '[gg]it open [q]uickfix list of hunks' })
          map('n', '<leader>ggd', gs.diffthis, { desc = '[gg]it [d]iff against index' })
          map('n', '<leader>ggD', function()
            gs.diffthis '~'
          end, { desc = '[gg]it [D]iff against last commit' })

          -- Toggles
          map('n', '<leader>ggtb', gs.toggle_current_line_blame, { desc = '[gg]it [t]oggle [b]lame line' })
          map('n', '<leader>ggtd', gs.toggle_deleted, { desc = '[gg]it [t]oggle [d]eleted' })
          map('n', '<leader>ggtn', gs.toggle_numhl, { desc = '[gg]it [t]oggle [n]umbers in column' })
          map('n', '<leader>ggth', gs.toggle_linehl, { desc = '[gg]it [t]oggle line [h]ightlights' })
          map('n', '<leader>ggts', gs.toggle_signs, { desc = '[gg]it [t]oggle [s]igns in column' })
          map('n', '<leader>ggtw', gs.toggle_word_diff, { desc = '[gg]it [t]oggle word diff' })

          -- Misc
          map('n', '<leader>ggla', gs.get_actions, { desc = '[gg]it [l]ist [a]ctions' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })

          -- next/prev git hunk
          map('n', '[g', ':Gitsigns prev_hunk wrap=false<CR>', { desc = 'Git Hunk previous' })
          map('n', ']g', ':Gitsigns next_hunk wrap=false<CR>', { desc = 'Git Hunk next' })

          vim.cmd([[hi GitSignsAdd guifg=#04de21]])
          vim.cmd([[hi GitSignsChange guifg=#83fce6]])
          vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
        end,

      })
    end,
  },

  --- Great Diff/Merge viewer
  -- maybe add `git config --global merge.tool nvimdiff` ?
  { 'diffview.nvim',
    enabled = gitEnabled,
    keys = {
      { '<leader>gdv', ':DiffviewOpen<CR>', desc = 'open [g]it [d]iff [v]iew' },
      { '<leader>gdc', ':DiffviewClose<CR>', desc = '[g]it [d]iff view [c]lose' },
      { '<leader>gda', ':DiffviewFileHistory<CR>', desc = '[g]it [d]iff view file history' },
      { '<leader>gdd', ':DiffviewFileHistory %<CR>', desc = '[g]it [dd]iff view file history on current buffer' },
      { '<leader>gds', ':DiffviewFileHistory -g --range=stash<CR>', desc = '[g]it [d]iff view file history on [s]tash' },
      {
        '<leader>gdD',
        [['<,'>DiffviewFileHistory]],
        desc = '[g]it [d]iff view file history on [s]tash',
        mode = 'v',
      },
    },
    after = function ()
      require('difffview').setup({
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = "diff2_vertical",
            winbar_info = true,
          },
          merge_tool = {
            layout = "diff3_mixed",
          },
          file_history = {
            layout = "diff2_vertical",
            winbar_info = true,
          },
        },
        keymaps = {
          file_panel = {
            { 'n', '<leader>q', '<cmd>DiffviewClose<cr>', { desc = 'Close GitdiffView' } }
          },
          file_history_panel = {
            { 'n', '<leader>q', '<cmd>DiffviewClose<cr>', { desc = 'Close GitdiffView' } }
          },
        }
      })
    end
  },

  -- new replacement for fugitive
  { 'neogit',
    enabled = gitEnabled,
    after = function ()
      require('neogit').setup({
        signs = {
          -- { CLOSED, OPENED }
          section = { "", "" },
          item = { "", "" },
          hunk = { "", "" },
        },
        integrations = { diffview = true }
      })
    end
  },

  { 'vim-fugitive',
    enabled = gitEnabled,
    cmd = {
      "G",
      "Git",
      "Ggrep",
      "Glgrep",
      "Gclog",
      "Gllog",
      "Gcd",
      "Glcd",
      "Gedit",
      "Gvsplit",
      "Gtabedit",
      "Gpedit",
      "Gdrop",
      "Gread",
      "Gwrite",
      "Gwq",
      "Gdiffsplit",
      "Ghdiffsplit",
      "GMove",
      "GRename",
      "GDelete",
      "GRemove",
      "GUnlink",
      "GBrowse",
    },
    keys = {
      -- Telescope Git
      { '<leader>gfa', ':Telescope git_commits<CR>', desc = '[g]it [f]ind [a] commits' },
      { '<leader>gfb', ':Telescope git_branches<CR>', desc = '[g]it [f]ind [b]ranches' },
      { '<leader>gfc', ':Telescope git_bcommits<CR>', desc = '[g]it [f]ind [c]ommits' },
      { '<leader>gff', ':Telescope git_files<CR>', desc = '[g]it [f]ind [f]iles' },

      -- browse
      { "<leader>ggg", ':Neogit<CR>', desc = 'Open Neogit', },
      { "<leader>gs", ':Git<CR>', desc = '[g]it [s]tatus', },
      { "<leader>gb", ':Git blame<CR>', desc = '[g]it open [b]lame list', },
      { "<leader>gB", ':GBrowse<CR>', desc = '[g]it [B]rowse (open in a browser)', },
      { "<leader>gq", ':0Gclog<CR>', desc = '[g]it open commit log in [q]uickfix list for current buffer', },
      { "<leader>gQ", ':Gclog<CR>', desc = '[g]it open commit log in [Q]uickfix list', },

      -- commit/stage
      { "<leader>gc", ':Git commit -v -q<CR>', desc = '[g]it [c]ommit', },
      { "<leader>gC", ':Git commit -v -q --amend<CR>', desc = '[g]it [C]ommit + amend', },
      { "<leader>gw", ':Gwrite<CR>', desc = '[g]it [w]rite + stage current file', },
      { "<leader>gm", ':Git merge<CR>', desc = '[g]it [m]erge', },

      -- diffs
      { "<leader>gdd", ':Gdiff<CR>', desc = '[g]it [dd]iff to staged', },
      { "<leader>gdh", ':Gdiff HEAD<CR>', desc = '[g]it [d]iff to last commit on [h]ead (HEAD branch)', },
      { "<leader>gdo", ':Gdiff origin/HEAD<CR>', desc = '[g]it [d]iff to last commit on [o]rigin/HEAD', },

      -- hunks
      -- map('n', '<leader>ga', ':GitGutterStageHunk<cr>', { desc = '[a]: Gutter Stage Hunk' })
      -- map('n', '<leader>gj', ':GitGutterNextHunk<cr>', { desc = '[j]: Go to next hunk' })
      -- map('n', '<leader>gk', ':GitGutterPrevHunk<cr>', { desc = '[k]: Go to prev hunk' })
      -- map('n', '<leader>gu', ':GitGutterUndoHunk<cr>', { desc = 'Gutter [u]ndo Hunk' })

      -- push/pull
      { "<leader>gpp", ':Git pull<CR>', desc = '[g]it [pp]ull', },
      { "<leader>gpP", ':Git push<CR>', desc = '[g]it [pP]ush', },
      { "<leader>gpo", ':Git pull origin<CR>', desc = '[g]it [p]ull from [o]rigin', },
      { "<leader>gpO", ':Git push origin<CR>', desc = '[g]it [p]ush to [O]rigin', },
      { "<leader>gpu", ':Git pull upstream<CR>', desc = '[g]it [p]ull from [u]pstream', },
      { "<leader>gpU", ':Git push upstream<CR>', desc = '[g]it [p]ush to [U]pstream', },
      { "<leader>gpf", function ()
         vim.cmd("Git push -u origin "..GitCurrentBranchName())
      end, desc = '[g]it [p]ush to origin for [f]irst time', },
    }
  },

  { "gitlineage.nvim",
    enabled = gitEnabled,
    after = function()
        require("gitlineage").setup()
    end
  }
}
