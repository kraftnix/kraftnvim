return {
  { 'ruifm/gitlinker.nvim',
    dependencies = {
      'ojroques/nvim-osc52',
      'nvim-lua/plenary.nvim',
    },
    config = function ()
      local gl = require 'gitlinker'
      local git = require 'gitlinker.git'
      local opts = require 'gitlinker.opts'
      local hosts = require 'gitlinker.hosts'
      local actions = require 'gitlinker.actions'
      local callbacks = {
        ["gitlab.com"] = hosts.get_gitlab_type_url,
        ["codeberg.org"] = hosts.get_gitea_type_url,
      }
      local nixCatsCallbacks = nixCats('gitlinker_callbacks')
      for url, callback_type in pairs(nixCatsCallbacks) do
        if hosts[callback_type] then
          callbacks[url] = hosts[callback_type]
        else
          print("Failed to find callback_type("..callback_type..") for url("..url..")")
        end
      end
      gl.setup({
        callbacks = callbacks,
        opts = {
          action_callback = function(url)
            -- yank to unnamed register
            vim.api.nvim_command('let @" = \'' .. url .. '\'')
            -- and copy to the system clipboard using OSC52
            require('osc52').copy(url)
          end,
        },
      })

      -- Custom gitea-only fetch-commit url
      local function get_buf_range_url_data(mode, user_opts)
        local git_root = git.get_git_root()
        if not git_root then
          vim.notify("Not in a git repository", vim.log.levels.ERROR)
          return nil
        end
        mode = mode or "n"
        local remote = git.get_branch_remote() or user_opts.remote
        local repo_url_data = git.get_repo_data(remote)
        if not repo_url_data then
          return nil
        end

        local rev = git.get_closest_remote_compatible_rev(remote)
        if not rev then
          return nil
        end

        return vim.tbl_extend("force", repo_url_data, { rev = rev, })
      end

      --- Constructs a gitea style url
      local function get_gitea_type_url(url_data)
        local url = gl.hosts.get_base_https_url(url_data)
        if not url_data.rev then
          return url
        end
        url = url .. "/commit/" .. url_data.rev
        return url
      end


      local function get_buf_range_url(mode, user_opts)
        user_opts = vim.tbl_deep_extend("force", opts.get(), user_opts or {})

        local url_data = get_buf_range_url_data(mode, user_opts)
        if not url_data then
          return nil
        end

        local url = get_gitea_type_url(url_data)

        if user_opts.action_callback then
          user_opts.action_callback(url)
        end
        if user_opts.print_url then
          vim.notify(url)
        end

        return url
      end

      local function open_commit_in_browser(mode, open)
        return function ()
          local extra = {}
          if open then
            extra = {action_callback = actions.open_in_browser}
          end
          return get_buf_range_url(mode, extra)
        end
      end

      local function open_in_browser (mode)
        return function ()
          gl.get_buf_range_url(mode, {action_callback = actions.open_in_browser})
        end
      end

      local function trimFinalNewlineMulti(str)
        return string.gsub(str, "[\r\n]*$", "")
      end

      local function get_notes_commit_message(mode, user_opts)
        return function ()
          local url = get_buf_range_url(mode, {print_url = false, action_callback = false})
          local commit = vim.fn.system([[git log -1 --pretty=%B]])
          local lines = {}
          for s in commit:gmatch("[^\r\n]+") do
              table.insert(lines, s)
          end
          local recombined = ""
          local i = 0
          for _,l in ipairs(lines) do
            if i == 0 then
              recombined = l.." [commit 🖋️]("..url..")"
            else
              recombined = recombined.."\n"..l
            end
            i = i + 1
          end
          local snippet = trimFinalNewlineMulti(recombined)
          user_opts = vim.tbl_deep_extend("force", opts.get(), user_opts or {})
          if user_opts.action_callback then
            user_opts.action_callback(snippet)
          end
          if user_opts.print_url then
            vim.notify(snippet)
          end
          return snippet
        end
      end

      local keymaps = {
        -- copy commit snippet for notes
        { '<leader>gyn',
          {
            n = get_notes_commit_message('n'),
            v = get_notes_commit_message('v'),
          },
          description = 'Copy commit markdown snippet for notes',
          opts = { silent = true, noremap = true },
        },
        -- copy url of current buffer
        { '<leader>gyy',
          { n = gl.get_buf_range_url, v = gl.get_buf_range_url },
          description = 'Copy file URL of current buffer',
          opts = { silent = true, noremap = true },
        },
        -- copy current commit URL
        { '<leader>gyc',
          { n = open_commit_in_browser('n', false), v = open_commit_in_browser('v', false) },
          description = 'Copy URL of current commit',
          opts = { silent = true, noremap = true },
        },
        -- open current commit in browser
        { '<leader>gyC',
          { n = open_commit_in_browser('n', true), v = open_commit_in_browser('v', true) },
          description = 'Open URL of current commit',
          opts = { silent = true, noremap = true },
        },
        -- open current buffer url in browser
        { '<leader>gyb',
          { n = open_in_browser('n'), v = open_in_browser('v') },
          description = 'Open current buffer in browser',
          opts = { silent = true, noremap = true },
        },
        -- open repo homepage/git url
        { '<leader>gyR',
          function ()
            gl.get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})
          end,
          description = 'Open Repo URL in browser',
          opts = { silent = true }
        },
        -- copy repo homepage/git url
        { '<leader>gyr', gl.get_repo_url, description = 'Copy Repo URL', opts = { silent = true } }
      }

      require('legendary').keymap({
        itemgroup = 'Git Linker',
        icon = '📜',
        description = "Copy/Open URL's of web pages",
        keymaps = keymaps
      })

    end

  }
}
