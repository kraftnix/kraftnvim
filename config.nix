{ self, nixpkgs, nixCats, packages, ... }@inputs:
let
  inherit (nixCats) utils;
  categories = {
    general = true;
    gitPlugins = true;
    customPlugins = true;
    test = true;
    telescope = true;
    treesitter = true;
    mini_starter = false;
    snacks_dashboard = true;
    snacks_terminal = false; # will use when i can figure out how to style terminal better
    terminal_nvim = true;
    # snacks_terminal = true;
    # terminal_nvim = false;
    debug = true;
    # cmp = true;
    # cmpCmdline = true;
    blink = true;
    oscyank = true;
    gitlinker_callbacks = {
      "gitea.home.lan" = "get_gitea_type_url";
    };
    colorful-menu = true;
    extra = true;
    always = true;

    have_nerd_font = true;
  };
in
{

  # see :help nixCats.flake.outputs.overlays
  dependencyOverlays = [
    packages.overlays.vimPlugins
    # This overlay grabs all the inputs named in the format
    # `plugins-<pluginName>`
    # Once we add this overlay to our nixpkgs, we are able to
    # use `pkgs.neovimPlugins`, which is a set of our plugins.
    (utils.standardPluginOverlay inputs)
  ];

  # see :help nixCats.flake.outputs.categories
  #     :help nixCats.flake.outputs.categoryDefinitions.scheme
  categoryDefinitions = { pkgs, settings, categories, extra, name, mkNvimPlugin, ... }@packageDef: {
    # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

    lspsAndRuntimeDeps = with pkgs; {
      general = [
        # universal-ctags
        ripgrep
        git
        fd
        stdenv.cc.cc
        nix-doc
        manix
        # stylua

        lua-language-server
        nil
        nixd
        nixfmt-rfc-style
        gopls
        nodePackages.bash-language-server
        pyright
        nodePackages.yaml-language-server
        nodePackages.dockerfile-language-server-nodejs
        docker-compose-language-service
        zk
      ];
      kickstart-debug = [
        delve
      ];
      kickstart-lint = [
        markdownlint-cli
      ];
    };

    startupPlugins = with pkgs.vimPlugins; {
      general = [
        ## Lib
        plenary-nvim # toolbox/lib for many libs
        middleclass-nvim # smarter class implementation
        tokyonight-nvim
        lazy-nvim

        oil-nvim
        nvim-web-devicons

        ## UI
        snacks-nvim # A collection of QoL plugins for Neovim 
        lualine-nvim # status/tabline
        dressing-nvim # pretty/glossy vim.ui.{select|input}
        nvim-web-devicons # nerd fonts for nvim
        nvim-colorizer-lua # highlight hex codes with their colour
        noice-nvim # meta UI plugin, message routing, lsp, cmdline, etc.
        nui-nvim # UI library (noice + dap-ui)
        nvim-notify # notification handler (used by noice)
        tabline-nvim # tabline (old, replaced by lualine)
        zen-mode-nvim # remove distractions
        urlview-nvim # picker (ui.select support) for URLs

        ## LSP
        nvim-lspconfig # configure LSPs
        neodev-nvim # configure lua + neovim projects
        nvim-nu # old-school null-ls nushell LSP
        none-ls-nvim # none-ls (language agnostic LSP)
        lsp_signature-nvim # LSP Signature Info (old, noice instead)
        lspkind-nvim # LSP Icons (can use in cmp)
        lspsaga-nvim # LSP extra functions
        trouble-nvim # LSP extra functions
        nvim-luadev # repl you can run in neovim for lua code
        vim-doge # documentation generation (lua)
        neogen # better annotation generation
        nvim-devdocs # open devdocs.io from vim
      ];
    };

    # in `lazy.nvim` setup, this is the same as `startupPlugins`
    optionalPlugins = {
      debug = with pkgs.vimPlugins; {
        # it is possible to add default values.
        # there is nothing special about the word "default"
        # but we have turned this subcategory into a default value
        # via the extraCats section at the bottom of categoryDefinitions.
        default = [
          ## Dap
          nvim-dap # Debug Adapter Protocol
          nvim-dap-ui # nui based ui for DAP
          nvim-nio # required by nvim-dap-ui
          nvim-dap-virtual-text # UI / Highlight for DAP virtual text
          one-small-step-for-vimkind-nvim # lua dap adapter
          telescope-dap-nvim # telescope picker for DAP
          nvim-dap-python # python dap adapter
        ];
        go = [ nvim-dap-go ];
      };
      lint = with pkgs.vimPlugins; [
        nvim-lint
      ];
      format = with pkgs.vimPlugins; [
        conform-nvim
      ];
      markdown = with pkgs.vimPlugins; [
        markdown-preview-nvim
      ];
      neonixdev = with pkgs.vimPlugins; [
        lazydev-nvim
      ];
      general = {
        terminal = with pkgs.vimPlugins; [
          toggleterm-nvim # toggle terminals in floating windows (old)
          terminal-nvim # toggle terminals
        ];
        colorful-menu = with pkgs.vimPlugins; [
          colorful-menu-nvim
        ];
        blink = with pkgs.vimPlugins; [
          blink-cmp
          blink-compat
          blink-ripgrep-nvim
          # minuet-ai-nvim
        ];
        snippets = with pkgs.vimPlugins; [
          luasnip # luasnip snippets
          nvim-scissors
          sniprun # run snippets with a binding (lua + rust)
          friendly-snippets # extra snippet source
        ];
        cmp = with pkgs.vimPlugins; [
          # cmp stuff
          cmp-nvim-lua
          cmp-nvim-lsp-signature-help
          lspkind-nvim

          ## cmp + snippets
          nvim-cmp # core
          cmp-nvim-lsp # lsp completions
          cmp-cmdline # wilder equiv
          cmp-cmdline-history # include history of commands/searchs
          cmp-buffer # buffer sources
          cmp-path # path sources
          cmp-async-path # path (async) sources
          cmp-treesitter # treesitter sources
          cmp-rg # rg source, searches well across buffers
          cmp-under-comparator # lowers priority of __ in completions (comparator)
          cmp_luasnip # complete luasnip snippets in cmp (source)
          wilder-nvim # cmdline/search completion (use cmp now)
          cpsm # wilder dependency
        ];
        treesitter = with pkgs.vimPlugins; [
          nvim-treesitter-textobjects # move/swap/peek/select objects
          nvim-treesitter-textsubjects # select textsubjects up/down
          nvim-treesitter-context # conceals top part of screen in deeply nested code
          nvim-treesitter-refactor # smart rename (current scope) + highlight scope + backup go to def/ref
          nvim-ts-context-commentstring # add commentstring context to treesitter
          rainbow-delimiters-nvim # fancy rainbow brackets
          playground

          nvim-treesitter.withAllGrammars
          # old override, no longer needed
          # ((pkgs.neovimUtils.grammarToPlugin pkgs.tree-sitter-grammars.tree-sitter-nu).overrideAttrs { installQueries = true; })
        ];
        telescope = with pkgs.vimPlugins; [
          telescope-nvim # picker
          telescope-fzf-native-nvim # use fzf-native for faster search
          telescope-file-browser-nvim # file browser
          telescope-live-grep-args-nvim # use rg for search
          telescope-manix # nix manix manual search
          telescope-cheat-nvim # cheatsheet (cheat.sh)
          telescope-tabs # tabs
          telescope-env # host ENV vars
          telescope-zoxide # lookup and use host zoxide
          telescope-menufacture # nice submenus in some core builtins
          telescope-all-recent # frecency sorting for telescope pickers
          telescope-project-nvim # search git repos in your home dir + cwd to them
          telescope-undo # undo history
          telescope-lazy-nvim # lazy plugins searcher (includes code search, reload, etc.)
          telescope-changes # changelist history (vendored)
          telescope-luasnip # luasnip snippet lookup + use
          telescope-lsp-handlers-nvim # lsp handlers integration
          browser-bookmarks-nvim # firefox browser lookup
          easypick-nvim # quickly make telescope pickers for external cli calls
          telescope-ui-select-nvim # use telescope for autocomplete
        ];
        always = with pkgs.vimPlugins; [
          # misc
          mini-nvim # mini tools (lots of things)
          fzf-vim # another fuzzy search tool/picker
          fzf-lua # another fuzzy search tool/picker
          pkgs.fzf # for above
          dial-nvim # smart increment/decrement
          comment-nvim # comments with easy motion
          todo-comments-nvim # highlight comments
          sqlite-lua # sqlite API (used by other plugins)
          nvim-osc52 # yank out of neovim through ssh/tmux with OSC52 escape
          vim-suda # sudo write file with w!!
          vim-sleuth # detect tabstop and shiftwidth automatically

          # git
          vim-fugitive # tpope git core plugin
          gitlinker-nvim # open/copy external git forge links (GBrowse replacement)
          gitsigns-nvim # git signs in the columns
          diffview-nvim # Diif/Merge view UI
          neogit # new Magit based Git UI

          # Movement / buffer mgmt
          treesj # fancy split/join of TS objects
          nvim-autopairs # pair up brackets/quotes etc.
          nvim-surround       # easily change pairs (i.e. "" -> '')
          flash-nvim # jump around with f,t,s
          quickselect-nvim # jump to matches like wezterm quickselect mode
          harpoon # mark buffers and jump between them
          portal-nvim # jump around lists with keys
          neoscroll-nvim # animated/speed scrolling (laggy over SSH tho)
          nvim-surround # autopairs ()[]<>{} completion (with treesitter magic)
        ];
        extra = with pkgs.vimPlugins; [
          fidget-nvim
          # lualine-lsp-progress
          comment-nvim
          undotree
          indent-blankline-nvim
          vim-startuptime
          # If it was included in your flake inputs as plugins-hlargs,
          # this would be how to add that plugin in your config.
          # pkgs.neovimPlugins.hlargs

          # keys
          which-key-nvim # popups for key combos
          legendary-nvim # cmd/keymapper with a picker
          commander-nvim # another cmd/keymapper with a picker

          glow-nvim # markdown preview
          zk-nvim # zk knowledge base lsp
          nvim-neoclip-lua # clipboard/macro manager

          # find/replace
          ssr-nvim # treesitter-based structural search
          inc-rename-nvim # incremental rename
          nvim-spectre # hardcore find replace

          ## File Manager
          fm-nvim # generic file manager for cli tools (ranger)
          oil-nvim # nvim file manager in buffer
          neo-tree-nvim # tree-based file structure in side panel
          yazi-nvim # integrate yazi + nvim

          # Lists
          vim-togglelist # simple, add vim commands for toggle quickfix/loclist TODO: replace
          nvim-bqf # better quick fix list, has a hover TODO: replace with trouble
        ];
      };
    };

    # shared libraries to be added to LD_LIBRARY_PATH
    # variable available to nvim runtime
    sharedLibraries = {
      general = with pkgs; [
        libgit2
      ];
    };

    # environmentVariables:
    # this section is for environmentVariables that should be available
    # at RUN TIME for plugins. Will be available to path within neovim terminal
    environmentVariables = {
      test = {
        # CATTESTVAR = "It worked!";
      };
    };

    # If you know what these are, you can provide custom ones by category here.
    # If you dont, check this link out:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
    extraWrapperArgs = {
      local = [
        # NOTE(workaround): wrapper script from nixCats sets NVIM_APPNAME=nvim, nullifying runtime overrides
        # instead you can set $KRAFTNVIM_NAME to override the NVIM_APPNAME
        # useful for local testing
        '' --run 'export NVIM_APPNAME="''${KRAFTNVIM_NAME:-$NVIM_APPNAME}"' ''
      ];
    };

    # lists of the functions you would have passed to
    # python.withPackages or lua.withPackages

    # get the path to this python environment
    # in your lua config via
    # vim.g.python3_host_prog
    # or run from nvim terminal via :!<packagename>-python3
    extraPython3Packages = {
      test = (_:[]);
    };
    # populates $LUA_PATH and $LUA_CPATH
    extraLuaPackages = {
      test = [ (_:[]) ];
    };
  };

  # And then build a package with specific categories from above here:
  # All categories you wish to include must be marked true,
  # but false may be omitted.
  # This entire set is also passed to nixCats for querying within the lua.

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    kraftnvim = { pkgs, ... }@args: {
      # see :help nixCats.flake.outputs.settings
      settings.wrapRc = true;
      settings.configDirName = "kraftnvim";
      settings.neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      categories = categories // {
        configDirName = "kraftnvim";
      };
    };
    kraftnvimLocal = { pkgs , ... }: {
      settings.wrapRc = false;
      # settings.configDirName = "kraftnvim";
      settings.neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      categories = categories // {
        local = true;
      };
    };
    kraftnvimStable = { ... }: {
      settings.wrapRc = true;
      settings.configDirName = "kraftnvim";
      categories = categories // {
        configDirName = "kraftnvim";
      };
    };
    kraftnvimStableLocal = { ... }: {
      settings.wrapRc = false;
      # settings.configDirName = "kraftnvimStable";
      categories = categories // {
        local = true;
      };
    };
  };
}
