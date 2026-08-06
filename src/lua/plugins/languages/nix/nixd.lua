local hostname = vim.fn.hostname()
local user = vim.fn.getenv("USER")
local config_flake = '(builtins.getFlake "git+file:///home/'..user..'/config")'
local curr_flake_let_in = 'let currFlake = builtins.getFlake ("git+file://" + toString ./.); in'
return {
  "nixd",
  enabled = nixInfo(false, "settings", "languages", "lsp", "enable"),
  for_cat = "nix",
  lsp = {
    cmd = { "nixd", "--inlay-hints=true", "--semantic-tokens=true", },
    -- cmd = { "nixd", "--inlay-hints=true", "--semantic-tokens=true", "--nixpkgs-worker-stderr=~/.local/share/nvim/nixd-worker.log", "--option-worker-stderr=~/.local/share/nvim/nixd-worker.log'" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
      nixd = {
        nixpkgs = {
          -- expr = "import <nixpkgs> { }",
          expr = 'import '..config_flake..'.inputs.nixpkgs { }',
        },
        formatting = {
          command = { "nixfmt" },
        },
        options = {
          nixos = {
            expr = '('..curr_flake_let_in..' if (builtins.hasAttr "nixd" currFlake) && (builtins.hasAttr "nixos" currFlake.nixd.options) then currFlake.nixd.options.nixos else if (builtins.hasAttr "nixosConfigurations" '..config_flake..') then '..config_flake..'.nixosConfigurations.' .. hostname .. '.options else {})',

            -- expr = config_flake..'.nixosConfigurations.'..hostname..'.options',
          },
          -- nixos_currflake = {
          --   expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixd.options.nixos'
          -- },
          home_manager = {
            expr = '('..curr_flake_let_in..' if (builtins.hasAttr "nixd" currFlake) && (builtins.hasAttr "home-manager" currFlake.nixd.options) then currFlake.nixd.options.home-manager else if (builtins.hasAttr "homeConfigurations" '..config_flake..') && (builtins.hasAttr "'..user..'" '..config_flake..'.homeConfigurations) then '..config_flake..'.homeConfigurations.' .. user .. '.options else {})',
            -- expr = config_flake..'.homeConfigurations.'..user..'.options',
          },
          -- -- home_manager_currflake = {
          -- --   expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixd.options.home-manager'
          -- -- },
          flake_parts = {
            expr = '('..curr_flake_let_in..' if builtins.hasAttr "debug" currFlake then currFlake.debug.options else {})',
          },
          perSystem = {
            expr = '('..curr_flake_let_in..' if builtins.hasAttr "currentSystem" currFlake then currFlake.currentSystem.options else {})',
          },
        },
        diagnostic = {
          suppress = {
            "sema-escaping-with"
          }
        }
      }
    },
  },
}
