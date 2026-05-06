inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkOption
    types
    ;
  mkEnableTrue = description: mkOption {
    inherit description;
    default = true;
    type = types.bool;
  };
  mkString = description: default: mkOption {
    inherit description default;
    type = types.str;
  };
in
{
  imports = [ wlib.wrapperModules.neovim ];
  # NOTE: see the tips and tricks section or the bottom of this file + flake inputs to understand this value
  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    # Makes plugins autobuilt from our inputs available with
    # `config.nvim-lib.neovimPlugins.<name_without_prefix>`
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };

  # choose a directory for your config.
  config.settings.config_directory = ./src;
  # you can also use an impure path!
  # config.settings.config_directory = lib.generators.mkLuaInline "vim.fn.stdpath('config')";
  # config.settings.config_directory = "/home/<USER>/.config/nvim";
  # If you do that, it will not be provisioned by nix, but it will have normal reload for quick edits!

  # Prevents path collision for multi neovim derivations
  config.settings.dont_link = true;

  # and make sure these dont share values:
  # config.binName = "nvim";
  # config.settings.aliases = [ ];

  # You can declare your own options!
  options.settings.colorscheme = lib.mkOption {
    type = lib.types.str;
    default = "onedark_dark";
  };
  config.settings.colorscheme = "tokyonight-night";
  # and grab it in lua with `require(vim.g.nix_info_plugin_name)("onedark_dark", "settings", "colorscheme") == "moonfly"`
  config.specs.colorscheme = {
    lazy = true;
    data = builtins.getAttr config.settings.colorscheme (
      with pkgs.vimPlugins;
      {
        "onedark_dark" = onedarkpro-nvim;
        "onedark_vivid" = onedarkpro-nvim;
        "tokyonight-night" = tokyonight-nvim;
        "onedark" = onedarkpro-nvim;
        "onelight" = onedarkpro-nvim;
        "moonfly" = vim-moonfly-colors;
      }
    );
  };

  options.settings.completion = {
    default = mkOption {
      description = "Default completion engine to use.";
      default = "blink";
      type = types.enum [ "blink" ];
    };
    commandline = mkOption {
      description = "Commandline completion engine to use.";
      default = "blink";
      type = types.enum [ "blink" ];
    };
  };

  config.specs.blink = {
    enable = config.settings.completion.default == "blink" || config.settings.completion.commandline == "blink";
    data = with pkgs.vimPlugins; [
      blink-ripgrep-nvim # provider: ripgrep / rg
      blink-cmp-conventional-commits # provider: git commits
      colorful-menu-nvim
      blink-cmp # compat for cmp
      blink-compat # compat for cmp
      cmp-cmdline # wilder equiv
      cmp-cmdline-history # include history of commands/searchs
      lspkind-nvim # LSP Icons (can use in cmp)
      nvim-web-devicons # nerd fonts for nvim
    ];
    extraPackages = with pkgs; [
      ripgrep
    ];
  };

  # `:lua require('lzextras').debug.display(require(vim.g.nix_info_plugin_name))`
  options.settings.snacks = {
    enable = mkEnableTrue "enable snacks integration";
    dashboard = mkEnableTrue "enable snacks dashboard integration";
    terminal = mkEnableOption "enable snacks terminal integration";
  };
  options.settings.languages = {
    nix.enable = mkEnableTrue "enable nixd integration";
    lua.enable = mkEnableTrue "enable lua lsp + extra config";
    rust.enable = mkEnableTrue "enable rust via rust-analyzer + add cargo config";
    java = {
      # enable = mkEnableTrue "enable nvim-java + jdtls";
      enable = mkEnableOption "enable nvim-java + jdtls";
      jdtls = mkString "path to jdtls binary" "${pkgs.jdt-language-server}/share/java/jdtls";
      lombok = mkString "path to lombok jar" "${pkgs.lombok}/share/java/lombok.jar";
      vscode-java-debug = mkString "path to vscode-java-debug extension" "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
      vscode-java-test = mkString "path to vscode-java-test extension" "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
    };
  };

  # If the defaults are fine, you can just provide the `.data` field
  # In this case, a list of specs, instead of a single plugin like above
  config.specs.lze = [
    # if defaults is fine, you can just provide the `.data` field
    config.nvim-lib.neovimPlugins.lze
    # but these can be specs too!
    {
      # these ones can't take lists though
      data = config.nvim-lib.neovimPlugins.lzextras;
      # things can target any spec that has a name.
      name = "lzextras";
      # now something else can be after = [ "lzextras" ]
      # the spec name is not the plugin name.
      # to override the plugin name, use `pname`
      # You could run something before your main init.lua like this
      # before = [ "INIT_MAIN" ];
      # You can include configuration and translated nix values here as well!
      # type = "lua"; # | "fnl" | "vim"
      # info = { };
      # config = ''
      #   local info, pname, lazy = ...
      # '';
    }
  ];

  config.specs.rust = {
    enable = config.settings.languages.rust.enable;
    data = null;
    extraPackages = with pkgs; [
      cargo
      gcc
      rust-analyzer
    ];
  };

  config.specs.java = {
    enable = config.settings.languages.java.enable;
    data = with pkgs.vimPlugins; [
      # nvim-java
      (nvim-java.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "olisikh";
          repo = "nvim-java";
          rev = "4dd43374a5488775e68f0d3548cd9fdea6718307";
          fetchSubmodules = false;
          sha256 = "sha256-5wkHJCFYB7pkDKU6EJ3UvTCKvCZiKkdWt7ypne1Yx04=";
        };
      }))
      nvim-jdtls
    ];
  };

  config.specs.nix = {
    enable = config.settings.languages.nix.enable;
    data = null;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };

  config.specs.lua = {
    enable = config.settings.languages.lua.enable;
    after = [ "general" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      lazydev-nvim
      nvim-luadev
      # replua # TODO(packages):
    ];
    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];
  };

  options.settings.noice.enable = mkEnableTrue "Enable noice UI improvements";
  config.specs.noice = {
    enable = config.settings.noice.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      noice-nvim # meta UI plugin, message routing, lsp, cmdline, etc.
      nui-nvim # UI library (noice + dap-ui)
      nvim-notify # notification handler (used by noice)
    ];
  };

  options.settings.diagrams.enable = mkEnableTrue "Enable image + diagrams plugins";
  options.settings.diagrams.d2 = mkEnableOption "Enable d2 diagrams";
  config.settings.nvim_lua_env = lp: [
    lp.magick
  ];
  config.specs.diagrams = {
    enable = config.settings.diagrams.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      image-nvim
      diagram-nvim
    ] ++ (lib.optionals config.settings.diagrams.d2 [
      # tree-sitter-d2
    ]);
    extraPackages = [ pkgs.imagemagick ];
  };

  config.specs.general = {
    after = [ "lze" ];
    extraPackages = with pkgs; [
      lazygit
      tree-sitter
    ];
    lazy = true;
    # here we chose a DAL of plugins, but we can also pass a single plugin, or null
    # plugins are of type wlib.types.stringable
    data = with pkgs.vimPlugins; [
      {
        data = vim-sleuth;
        # You can override defaults from the parent spec here
        lazy = false;
      }
      snacks-nvim

      # UI
      colorful-menu-nvim
      lualine-nvim
      gitsigns-nvim
      fidget-nvim # lsp messages in hover
      tokyonight-nvim # required by noice atm
      nvim-colorizer-lua # highlight hex codes with their colour
      rainbow-delimiters-nvim # fancy rainbow brackets
      # neoscroll-nvim # animated/speed scrolling (laggy over SSH tho)
      urlview-nvim # picker (ui.select support) for URLs
      todo-comments-nvim # highlight comments

      # LSP / code
      nvim-lspconfig
      nvim-surround # autopairs ()[]<>{} completion (with treesitter magic)
      nvim-lint # nicer linting
      conform-nvim #nicer formatting

      # treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects

      # misc
      vim-startuptime
      which-key-nvim # popups for key combos
    ];
  };

  # These are from the tips and tricks section of the neovim wrapper docs!
  # https://birdeehub.github.io/nix-wrapper-modules/neovim.html#tips-and-tricks
  # We could put these in another module and import them here instead!

  # This submodule modifies both levels of your specs
  config.specMods =
    {
      # When this module is ran in an inner list,
      # this will contain `config` of the parent spec
      parentSpec ? null,
      # and this will contain `options`
      # otherwise they will be `null`
      parentOpts ? null,
      parentName ? null,
      # and then config from this one, as normal
      config,
      # and the other module arguments.
      ...
    }:
    {
      # you could use this to change defaults for the specs
      # config.collateGrammars = lib.mkDefault (parentSpec.collateGrammars or false);
      # config.autoconfig = lib.mkDefault (parentSpec.autoconfig or false);
      # config.runtimeDeps = lib.mkDefault (parentSpec.runtimeDeps or false);
      # config.pluginDeps = lib.mkDefault (parentSpec.pluginDeps or false);
      # or something more interesting like:
      # add an extraPackages field to the specs themselves
      options.extraPackages = lib.mkOption {
        type = lib.types.listOf wlib.types.stringable;
        default = [ ];
        description = "a extraPackages spec field to put packages to suffix to the PATH";
      };
      # You could do this too
      # config.before = lib.mkDefault [ "INIT_MAIN" ];
    };
  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

  # Inform our lua of which top level specs are enabled
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };
  # build plugins from inputs set
  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    default =
      prefix: inputs:
      lib.pipe inputs [
        builtins.attrNames
        (builtins.filter (s: lib.hasPrefix prefix s))
        (map (
          input:
          let
            name = lib.removePrefix prefix input;
          in
          {
            inherit name;
            value = config.nvim-lib.mkPlugin name inputs.${input};
          }
        ))
        builtins.listToAttrs
      ];
  };
}
