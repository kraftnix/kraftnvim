return {
  -- name of the lsp
  "lua_ls",
  enabled = nixInfo(false, "settings", "languages", "lua", "enable"),
  for_cat = "lua",
  -- provide a table containing filetypes,
  -- and then whatever your functions defined in the function type specs expect.
  -- in our case, it just expects the normal lspconfig setup options,
  -- but with a default on_attach and capabilities
  lsp = {
    -- if you provide the filetypes it doesn't ask lspconfig for the filetypes
    -- (meaning it doesn't call the callback function we defined in the main init.lua)
    filetypes = { 'lua' },
    settings = {
      Lua = {
        signatureHelp = { enabled = true },
        diagnostics = {
          globals = { "nixInfo", "vim", },
          disable = { 'missing-fields' },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.fn.expand "$VIMRUNTIME",
            -- '~/.config/nvim/nix-plugins',
            -- '~/.config/nvim/lazy-plugins',
            --get_lvim_base_dir(),
            -- require("neodev.config").types(),
            "${3rd}/busted/library",
            "${3rd}/luassert/library",
          },
          maxPreload = 5000,
          preloadFileSize = 10000,
        },
        telemetry = { enable = false },
      },
    },
  },
}
