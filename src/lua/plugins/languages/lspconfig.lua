return {
 'nvim-lspconfig',
  auto_enable = true,

  lsp = function(plugin)
    vim.lsp.config(plugin.name, plugin.lsp or {})
    vim.lsp.enable(plugin.name)
  end,

  -- set up our on_attach function once before the spec loads
  before = function(_)
    vim.lsp.config('*', {
      on_attach = function(_, bufnr)

        -- we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
        nmap('gi', vim.lsp.buf.implementation, '[G]oto [i]mplementation')
        nmap('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation (snacks)')
        nmap('<leader>ss', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
        nmap('<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>Wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        nmap('<leader>rf', function () vim.lsp.buf.format { async = true } end, '[G]oto [i]mplementation')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end
    })
  end,

  after = function(_)
    -- bash
    vim.lsp.enable('bashls')
    vim.lsp.config('bashls', {
      cmd = { "bash-language-server" },
    })

    vim.lsp.enable('gopls')
    vim.lsp.config('gopls', {
      cmd = { "gopls" },
    })

    vim.lsp.enable('nushell')
    vim.lsp.config('nushell', {
      cmd = { "nu", "--lsp" }
    })

    -- python
    vim.lsp.enable('pyright')
    vim.lsp.config('pyright', {
      -- cmd = { "pyright" },
    })
    vim.lsp.enable('ruff')
    vim.lsp.config('ruff', {
      cmd = { "ruff", "server" },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    })

    -- rust
    vim.lsp.enable('rust_analyzer')
    vim.lsp.config('rust_analyzer', {
      cmd = { "rust-analyzer" },
    })

    vim.lsp.enable('dockerls') -- dockerfile
    vim.lsp.enable('docker_compose_language_service') -- docker-compose
    vim.lsp.enable('yamlls') -- yaml
    vim.lsp.enable('zk') -- zk / zettelkasten plugin
  end

}
