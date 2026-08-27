{ lib, callPackage, vimUtils, vimPlugins, tree-sitter, ... }@pkgs:
let
  inherit (lib)
    mapAttrs
    ;

  replaceDots = mapAttrs (name: plugin: plugin // {
    # required for lazy-loading to work properly for downstreams
    pname = plugin.src.repo;
  });
  sources = replaceDots (callPackage (import ./_sources/generated.nix) { });

  allVimPlugins = (import ./vim-plugin.nix pkgs sources [
      # "nvim-nu"
      "browser-bookmarks-nvim"
      "canola-nvim"
      "d2-vim"
      "nvim-devdocs"
      "easypick-nvim"
      "portal-nvim"
      "quickselect-nvim"
      "replua-nvim"
      "telescope-all-recent"
      "telescope-changes"
      "telescope-env"
      "telescope-luasnip"
      "telescope-gitsigns-nvim"
      "telescope-menufacture"
      "telescope-tabs"
      "terminal-nvim"
      "tree-sitter-d2"
    ]) // {
      gitlinker-nvim = pkgs.vimUtils.buildVimPlugin (
        sources.gitlinker-nvim // {
          version = builtins.substring 0 8 sources.gitlinker-nvim.version;
          # not a dependency, but is required due to spec_init
          dependencies = [ pkgs.vimPlugins.plenary-nvim ];
          patchPhase = ''
            substituteInPlace spec_init.lua \
              --replace-fail \
              'os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"' \
              '"${pkgs.vimPlugins.plenary-nvim}"'
          '';
        }
      );
    };
  vimPlugins = final: prev: let
    vp = allVimPlugins;
    up = pkgs.vimPlugins;
    filterTreesitter = plugins: lib.pipe plugins [
      (lib.filterAttrs (n: p: !(builtins.elem n [
        # "tree-sitter-razor" # broken
      ])))
    ];
    tree-sitter-d2-grammar = tree-sitter.buildGrammar {
      language = "d2";
      version = vp.tree-sitter-d2.version;
      src = vp.tree-sitter-d2.src;
      generate = true;
    };
  in vp // {
    nvim-devdocs = vp.nvim-devdocs.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
    };
    telescope-gitsigns-nvim = vp.telescope-gitsigns-nvim.overrideAttrs {
      dependencies = with up; [ gitsigns-nvim plenary-nvim telescope-nvim ];
    };
    browser-bookmarks-nvim = vp.browser-bookmarks-nvim.overrideAttrs {
      dependencies = with up; [ sqlite-lua ];
    };
    easypick-nvim = vp.easypick-nvim.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
    };
    telescope-all-recent = vp.telescope-all-recent.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim sqlite-lua ];
    };
    telescope-tabs = vp.telescope-tabs.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
    };
    tree-sitter-all = tree-sitter.withPlugins (p: (builtins.attrValues (filterTreesitter p)) ++ [
      tree-sitter-d2-grammar
    ]);
    nvim-treesitter-all = up.nvim-treesitter.withPlugins (
      plugins:
      up.nvim-treesitter.allGrammars
      ++ [ tree-sitter-d2-grammar ] # you had an extra buildGrammar here
    );
  };
  initialPackages = self: { };
in
lib.pipe initialPackages [
  (lib.extends vimPlugins)
  lib.makeExtensible
]
