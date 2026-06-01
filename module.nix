{
  inputs,
  packages,
}:
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
  localPlugins = packages.vimPlugins.${pkgs.stdenv.hostPlatform.system};
  mkEnableDefault = description: default: mkOption {
    inherit description default;
    type = types.bool;
  };
  mkEnableTrue = description: mkEnableDefault description true;
  mkString = description: default: mkOption {
    inherit description default;
    type = types.str;
  };
  telescope = config.settings.telescope;
  d2Enabled = config.settings.diagrams.d2;
  profile = config.settings.profile;
  isFullProfile = profile == "full";
  lspEnabled = config.settings.languages.lsp.enable;
  allLanguages = isFullProfile || config.settings.languages.enableAll;
  enabledInFull = lspEnabled && isFullProfile;
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
  config.binName = "kraftnvim";
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

  options.settings.profile = mkOption {
    description = "Profile to use for base config of the module";
    default = "full";
    type = types.enum [ "full" "minimal" ];
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
    lazy = true;
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
      trouble-nvim # pretty lists for diaganostics / lsp / quickfix etc.
    ];
    extraPackages = with pkgs; [
      ripgrep
    ];
  };

  options.settings.mini = {
    startpage = mkEnableOption "enable mini startpage integration";
  };
  options.settings.snacks = {
    enable = mkEnableTrue "enable snacks integration";
    startpage = mkEnableDefault "enable snacks dashboard integration" isFullProfile;
    terminal = mkEnableOption "enable snacks terminal integration";
  };
  options.settings.languages = {
    enableAll = mkEnableOption "enable all languages";
    lsp.enable = mkEnableDefault "enable lspconfig and lsps" allLanguages;
    bash.enable = mkEnableDefault "enable bashls lsp" enabledInFull;
    docker.enable = mkEnableDefault "enable docker + docker-compose lsp" enabledInFull;
    nix.enable = mkEnableDefault "enable nixd integration" enabledInFull;
    lua.enable = mkEnableDefault "enable lua lsp + extra config" enabledInFull;
    rust.enable = mkEnableDefault "enable rust via rust-analyzer + add cargo config" enabledInFull;
    python.enable = mkEnableDefault "enable python lsp" enabledInFull;
    go.enable = mkEnableDefault "enable gopls lsp" enabledInFull;
    nushell.enable = mkEnableDefault "enable nu lsp via own binary" enabledInFull;
    yaml.enable = mkEnableDefault "enable yamlls" enabledInFull;
    zk.enable = mkEnableDefault "enable zk / zettelkasten tool" (lspEnabled && allLanguages);
    java = {
      enable = mkEnableDefault "enable nvim-java + jdtls" (lspEnabled && allLanguages);
      jdtls = mkString "path to jdtls binary" "${pkgs.jdt-language-server}/share/java/jdtls";
      lombok = mkString "path to lombok jar" "${pkgs.lombok}/share/java/lombok.jar";
      vscode-java-debug = mkString "path to vscode-java-debug extension" "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
      vscode-java-test = mkString "path to vscode-java-test extension" "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
    };
  };
  config.specs.lsp = {
    enable = config.settings.languages.lsp.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      # LSP / code
      nvim-lspconfig # easier lsp config
      nvim-surround # autopairs ()[]<>{} completion (with treesitter magic)
      nvim-lint # nicer linting
      conform-nvim # nicer formatting
      lspsaga-nvim # LSP extra functions
    ];
    extraPackages = with pkgs; [
      stdenv.cc.cc
    ];
  };

  config.specs.bash = {
    enable = config.settings.languages.bash.enable;
    lazy = true;
    data = null;
    extraPackages = with pkgs; [
      bash-language-server
    ];
  };

  config.hosts.python3.withPackages = lib.mkIf config.specs.python.enable (
    ps: [
      ps.ruff
    ]
  );
  config.specs.python = {
    enable = config.settings.languages.python.enable;
    lazy = true;
    data = null;
    extraPackages = with pkgs; [
      ty
    ];
  };

  config.specs.yaml = {
    enable = config.settings.languages.yaml.enable;
    lazy = true;
    data = null;
    extraPackages = with pkgs; [
      yaml-language-server
    ];
  };

  config.specs.docker = {
    enable = config.settings.languages.docker.enable;
    lazy = true;
    data = null;
    extraPackages = with pkgs; [
      docker-ls
      docker-compose-language-service
    ];
  };

  config.specs.nushell = {
    enable = config.settings.languages.nushell.enable;
    data = null;
    extraPackages = with pkgs; [
      nushell
    ];
  };

  config.specs.zk = {
    enable = config.settings.languages.zk.enable;
    data = null;
    extraPackages = with pkgs; [
      zk
    ];
  };

  config.specs.rust = {
    enable = config.settings.languages.rust.enable;
    lazy = true;
    data = null;
    extraPackages = with pkgs; [
      cargo
      gcc
      rustc
      rust-analyzer
    ];
  };

  config.specs.go = {
    enable = config.settings.languages.go.enable;
    lazy = true;
    data = null;
    extraPackages = with pkgs; [
      gopls
    ];
  };

  config.specs.java = {
    enable = config.settings.languages.java.enable;
    lazy = true;
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
    lazy = true;
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
      localPlugins.replua-nvim
    ];
    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];
  };

  # options.settings.noice.enable = mkEnableDefault "Enable noice UI improvements" isFullProfile;
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

  options.settings.dap.enable = mkEnableDefault "Enable dap plugins" isFullProfile;
  config.specs.dap = {
    enable = config.settings.dap.enable;
    lazy = false;
    data = with pkgs.vimPlugins; [
      nvim-dap
      one-small-step-for-vimkind
    ];
  };

  options.settings.diagrams.enable = mkEnableDefault "Enable image + diagrams plugins" isFullProfile;
  options.settings.diagrams.d2 = mkEnableOption "Enable d2 diagrams";
  config.settings.nvim_lua_env = lp: lib.optionals config.settings.diagrams.enable [
    lp.magick
  ];
  config.specs.diagrams = {
    enable = config.settings.diagrams.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      image-nvim
      diagram-nvim
    ] ++ (lib.optionals config.settings.diagrams.d2 [
      localPlugins.tree-sitter-d2
      # localPlugins.d2-vim
    ]);
    extraPackages = with pkgs; [
      imagemagick
      mermaid-cli
    ] ++ (lib.optionals config.settings.diagrams.d2 [
      d2
    ]);
  };

  options.settings.git = {
    enable = mkEnableTrue "Enable git related plugins";
    gitlinker_callbacks = mkOption {
      description = ''
        Extra callbacks to add to gitlinker defaults. Provide a set of (url -> callback_type)

        Useful for adding extra forgejo/gitea/gitlab self-hosted instances.
      '';
      default = { };
      type = types.attrsOf types.str;
      example = {
        "forgejo.home.lan" = "forgejo";
      };
    };
  };
  config.specs.git = {
    enable = config.settings.git.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      gitsigns-nvim # git signs in the columns
      diffview-nvim # Diif/Merge view UI
      neogit # new Magit based Git UI
      vim-fugitive # tpope git core plugin
      gitlineage-nvim # Find previously commits that modified specific lines
      localPlugins.gitlinker-nvim # open/copy external git forge links (GBrowse replacement)
    ];
    extraPackages = [ pkgs.git ];
  };

  config.info.oscyank.enable = true;
  config.specs.oscyank = {
    enable = config.info.oscyank.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-osc52 # yank out of neovim through ssh/tmux with OSC52 escape
    ];
  };

  options.settings.telescope = {
    enable = mkEnableTrue "enable telescope";
    profile = mkOption {
      description = "Profile to use for telescope";
      default = profile;
      type = types.enum [ "full" "minimal" ];
      example = "minimal";
    };
    bookmarks = mkEnableTrue "enable browser-bookmarks picker";
  };
  config.specs.telescope = {
    enable = telescope.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      telescope-nvim # picker
      telescope-fzf-native-nvim # use fzf-native for faster search
      telescope-live-grep-args-nvim # use rg for search
      localPlugins.telescope-env # host ENV vars
      localPlugins.telescope-menufacture # nice submenus in some core builtins
    ] ++ (lib.optionals (telescope.profile == "full") [
      # telescope-all-recent # frecency sorting for telescope pickers
      telescope-cheat-nvim # cheatsheet (cheat.sh)
      telescope-file-browser-nvim # file browser
      telescope-manix # nix manix manual search
      telescope-project-nvim # search git repos in your home dir + cwd to them
      telescope-undo-nvim # undo history
      telescope-zoxide # lookup and use host zoxide
      localPlugins.telescope-tabs # tabs
      localPlugins.easypick-nvim # quickly make telescope pickers for external cli calls
    ]) ++ (lib.optionals telescope.bookmarks [
      localPlugins.browser-bookmarks-nvim # firefox browser lookup
    ]) ++ (lib.optionals config.settings.git.enable [
      localPlugins.telescope-gitsigns-nvim # picker got gitsigns
    ]) ++ (lib.optionals config.settings.snippets.enable [
      localPlugins.telescope-luasnip # luasnip snippet lookup + use
    ]);
    extraPackages = with pkgs; [
      fd
      ripgrep
    ] ++ (lib.optionals (telescope.profile == "full") [
      manix
      zoxide
    ]);
  };

  config.info.terminal-manager = "toggleterm";
  config.specs.terminal = {
    enable = config.info.terminal-manager != "";
    lazy = true;
    data = with pkgs.vimPlugins; []
      ++ (
        lib.optional
        (config.info.terminal-manager == "toggleterm")
        toggleterm-nvim # toggle terminals in floating windows (old)
      )
      ++ (
        lib.optional
        (config.info.terminal-manager == "terminal-nvim")
        terminal-nvim # toggle terminals
      );
  };

  options.settings.snippets = {
    enable = mkEnableDefault "enable snippets integration" isFullProfile;
    embeddedPaths = mkOption {
      description = "Embedded snippets from this repo";
      default = ./src/lua/luasnippets;
      type = types.path;
    };
    localPath = mkOption {
      description = "Local path (relative to .config/nvim) on host to search for snippets, if empty, not searched";
      default = "";
      type = types.str;
      example = "snippets";
    };
  };
  config.specs.snippets = {
    enable = config.settings.snippets.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      # snippets
      luasnip # luasnip snippets
      friendly-snippets # extra snippet source
      nvim-scissors # edit + create snippets
      sniprun # run snippets with a binding (lua + rust)
    ];
  };

  config.info.flash.enable = true;

  config.info.oil.enable = true;
  config.info.oil.useCanola = true; # maintained version
  config.specs.oil = {
    enable = config.info.oil.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      (if config.info.oil.useCanola
        then localPlugins.canola-nvim # maintained fork of oil-nvim
        else oil-nvim # buffer based file management
      )
      oil-git-nvim # git status alongside on files
      oil-lsp-diagnostics-nvim # lsp diagnostics icons on files
    ];
  };
  config.info.yazi.enable = true;
  config.specs.yazi = {
    enable = config.info.oil.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      yazi-nvim # integrate yazi + nvim
    ];
    extraPackages = [ pkgs.yazi ];
  };

  options.settings.docs.enable = mkEnableDefault "enable docs generation integration" isFullProfile;
  config.specs.docs = {
    enable = config.settings.docs.enable;
    lazy = true;
    data = with pkgs.vimPlugins; [
      # docs
      neogen # better annotation generation
      # vim-doge # documentation generation (lua)
      localPlugins.nvim-devdocs # open devdocs.io from vim
    ];
  };

  config.specs.general = {
    after = [ "lze" ];
    extraPackages = with pkgs; [
      lazygit
      fzf # for bqf
      (if d2Enabled then localPlugins.tree-sitter-all else tree-sitter)
    ];
    lazy = true;
    # here we chose a DAL of plugins, but we can also pass a single plugin, or null
    # plugins are of type wlib.types.stringable
    data = with pkgs.vimPlugins; [
      snacks-nvim
      mini-nvim # mini tools (lots of things)
      flash-nvim # jump around with f,t,s
      nvim-bqf # better quickfix list
      fzf-wrapper # fzf wrapper for junegunn/fzf

      # UI
      colorful-menu-nvim
      lualine-nvim
      fidget-nvim # lsp messages in hover
      tokyonight-nvim # required by noice atm
      nvim-colorizer-lua # highlight hex codes with their colour
      rainbow-delimiters-nvim # fancy rainbow brackets
      # neoscroll-nvim # animated/speed scrolling (laggy over SSH tho)
      urlview-nvim # picker (ui.select support) for URLs
      todo-comments-nvim # highlight comments
      neo-tree-nvim # tree-based file structure in side panel
      render-markdown-nvim # markdown preview

      # treesitter
      (if d2Enabled then localPlugins.nvim-treesitter-all else nvim-treesitter.withAllGrammars)
      nvim-treesitter-textobjects

      # misc
      vim-startuptime
      which-key-nvim # popups for key combos
      plenary-nvim # toolbox/lib for many libs
      harpoon # mark buffers and jump between them
      localPlugins.portal-nvim # jump around lists with keys
      grapple-nvim # jump around (successor to portal)
      guess-indent-nvim # guess indent on files
      vim-suda # sudo write on current file
      treesj # fancy split/join of TS objects
      comment-nvim # toggle comments on visual selection
      dial-nvim # smart increment/decrement
      localPlugins.quickselect-nvim # jump to matches like wezterm quickselect mode


      # find/replace
      ssr-nvim # treesitter-based structural search
      inc-rename-nvim # incremental rename
      nvim-spectre # hardcore find replace
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
