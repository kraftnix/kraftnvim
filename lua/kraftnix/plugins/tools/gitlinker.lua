return {
  { 'linrongbin16/gitlinker.nvim',
    dependencies = {
      'ojroques/nvim-osc52',
      'nvim-lua/plenary.nvim',
    },
    config = function ()
      --- @param s string
      --- @param t string
      local function string_endswith(s, t)
        return string.len(s) >= string.len(t) and string.sub(s, #s - #t + 1) == t
      end

      --- @param lk gitlinker.Linker
      local function get_commit(host)
        return function (lk)
          local repo = (string_endswith(lk.repo, ".git") and lk.repo:sub(1, #lk.repo - 4) or lk.repo)
          return "https://"
            ..host.."/"
            ..lk.org.."/"
            ..repo.."/commit/"
            ..lk.rev
        end
      end

      --- @param lk gitlinker.Linker
      local function get_repo(host)
        return function (lk)
          local repo = (string_endswith(lk.repo, ".git") and lk.repo:sub(1, #lk.repo - 4) or lk.repo)
          return "https://"
            ..host.."/"
            ..lk.org.."/"
            ..repo
        end
      end

      local function trimFinalNewlineMulti(str)
        return string.gsub(str, "[\r\n]*$", "")
      end

      --- @param lk gitlinker.Linker
      local function get_commit_md_note(host)
        return function (lk)
          local repo = (string_endswith(lk.repo, ".git") and lk.repo:sub(1, #lk.repo - 4) or lk.repo)
          local url = "https://"
            ..host.."/"
            ..lk.org.."/"
            ..repo.."/commit/"
            ..lk.rev
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
          return trimFinalNewlineMulti(recombined)
        end
      end

      local router = {
        browse = {
          -- ["gitea.home.lan"] = require('gitlinker.routers').codeberg_browse,
        },
        blame = {
          -- ["gitea.home.lan"] = require('gitlinker.routers').codeberg_blame,
        },
        default_branch = {

        },
        current_branch = {

        },
        commit = {
          ["bitbucket.org"] = get_commit("bitbucket.org"),
          ["codeberg.org"] = get_commit("codeberg.org"),
          ["github.com"] = get_commit("github.com"),
          ["gitlab.com"] = get_commit("gitlab.com"),
        },
        commit_note = {
          ["bitbucket.org"] = get_commit_md_note("bitbucket.org"),
          ["codeberg.org"] = get_commit_md_note("codeberg.org"),
          ["github.com"] = get_commit_md_note("github.com"),
          ["gitlab.com"] = get_commit_md_note("gitlab.com"),
        },
        repo_url = {
          ["bitbucket.org"] = get_repo("bitbucket.org"),
          ["codeberg.org"] = get_repo("codeberg.org"),
          ["github.com"] = get_repo("github.com"),
          ["gitlab.com"] = get_repo("gitlab.com"),
        }
      }

      local branch = function (b)
        return function (lk)
          local repo = (string_endswith(lk.repo, ".git") and lk.repo:sub(1, #lk.repo - 4) or lk.repo)
          local builder = "https://"
            ..lk.host.."/"
            ..lk.org.."/"
            ..repo.."/src/branch/"..lk[b].."/"
            ..lk.file
            ..string.format("#L%d", lk.lstart)
          if lk.lend > lk.lstart then
            builder = builder
            .. string.format("-L%d", lk.lend - lk.lstart + 1)
          end
          return builder
        end
      end

      local handlers = {
        forgejo = {
          blame = require('gitlinker.routers').codeberg_blame,
          browse = require('gitlinker.routers').codeberg_browse,
          current_branch = branch("current_branch"),
          default_branch = branch("default_branch"),
        }
      }

      local nixCatsCallbacks = nixCats('gitlinker_callbacks')
      for url, callback_type in pairs(nixCatsCallbacks) do
        if handlers[callback_type] then
          local h = handlers[callback_type]
          router['blame'][url] = h['blame']
          router['browse'][url] = h['browse']
          router['current_branch'][url] = h['current_branch']
          router['default_branch'][url] = h['default_branch']
          router['commit'][url] = get_commit(url)
          router['commit_note'][url] = get_commit_md_note(url)
          router['repo_url'][url] = get_repo(url)
        else
          print("Failed to find callback_type("..callback_type..") for url("..url..")")
        end
      end

      require('gitlinker').setup({
        router = router
      })

      local keymaps = {
        -- copy commit snippet for notes
        { '<leader>gyn',
          "<Cmd>GitLink commit_note<CR>",
          description = 'Copy commit markdown snippet for notes',
          opts = { silent = true, noremap = true },
        },
        -- copy url of current buffer
        { '<leader>gyy',
          { n = "<Cmd>GitLink<CR>", v = "<Cmd>GitLink<CR>" },
          description = 'Copy file URL of current buffer',
          opts = { silent = true, noremap = true },
        },
        -- open current buffer url in browser
        { '<leader>gyY',
          { n = "<Cmd>GitLink!<CR>", v = "<Cmd>GitLink!<CR>" },
          description = 'Open current buffer in browser',
          opts = { silent = true, noremap = true },
        },
        -- copy current commit URL
        { '<leader>gyc',
          { n = "<Cmd>GitLink commit<CR>", v = "<Cmd>GitLink commit<CR>" },
          description = 'Copy URL of current commit',
          opts = { silent = true, noremap = true },
        },
        -- open current commit in browser
        { '<leader>gyC',
          { n = "<Cmd>GitLink! commit<CR>", v = "<Cmd>GitLink! commit<CR>" },
          description = 'Open URL of current commit',
          opts = { silent = true, noremap = true },
        },
        -- copy url of blame for current buffer
        { '<leader>gyb',
          { n = "<Cmd>GitLink<CR>", v = "<Cmd>GitLink<CR>" },
          description = 'Copy blame URL of current buffer',
          opts = { silent = true, noremap = true },
        },
        -- open current blame for buffer in browser
        { '<leader>gyB',
          { n = "<Cmd>GitLink!<CR>", v = "<Cmd>GitLink!<CR>" },
          description = 'Open blame URL of current buffer in browser',
          opts = { silent = true, noremap = true },
        },
        -- copy url of current buffer
        { '<leader>gywc',
          { n = "<Cmd>GitLink current_branch<CR>", v = "<Cmd>GitLink current_branch<CR>" },
          description = 'Copy file URL of current buffer in current branch',
          opts = { silent = true, noremap = true },
        },
        -- open current buffer url in browser
        { '<leader>gywC',
          { n = "<Cmd>GitLink! current_branch<CR>", v = "<Cmd>GitLink! current_branch<CR>" },
          description = 'Open current buffer in current branch in browser',
          opts = { silent = true, noremap = true },
        },
        -- copy url of default branch
        { '<leader>gywd',
          { n = "<Cmd>GitLink default_branch<CR>", v = "<Cmd>GitLink default_branch<CR>" },
          description = 'Copy file URL of current buffer in default branch',
          opts = { silent = true, noremap = true },
        },
        -- open current buffer url in browser
        { '<leader>gywD',
          { n = "<Cmd>GitLink! default_branch<CR>", v = "<Cmd>GitLink! default_branch<CR>" },
          description = 'Open current buffer in default branch in browser',
          opts = { silent = true, noremap = true },
        },
        -- -- open repo homepage/git url
        { '<leader>gyr',
          { n = "<Cmd>GitLink repo_url<CR>", v = "<Cmd>GitLink repo_url<CR>" },
          description = 'Copy Repo URL',
          opts = { silent = true }
        },
        -- copy repo homepage/git url
        { '<leader>gyR',
          { n = "<Cmd>GitLink! repo_url<CR>", v = "<Cmd>GitLink! repo_url<CR>" },
          description = 'Open Repo URL in browser',
          opts = { silent = true }
        },
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
