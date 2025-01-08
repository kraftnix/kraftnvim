{ inputs, lib, ... }:
let
  inherit (lib)
    mapAttrs
    ;

  getPkgs = system: inputs.nixpkgs.legacyPackages.${system};

  replaceDots = mapAttrs (name: plugin: plugin // {
    # required for lazy-loading to work properly for downstreams
    pname = plugin.src.repo;
  });

  allVimPlugins =
    nixpkgs: sources:
    (import ./vim-plugin.nix nixpkgs sources [
      # "nvim-nu"
      "nvim-telescope-hop"
      "nvim-guess-indent"
      "neozoom-nvim"
      "sessions-nvim"
      "fm-nvim"
      "portal-nvim"
      "magma-nvim"
      "telescope-tabs"
      "vim-doge"
      "commander-nvim"
      "one-small-step-for-vimkind-nvim"
      "telescope-all-recent"
      "telescope-menufacture"
      "telescope-env"
      "telescope-undo"
      "telescope-changes"
      "telescope-luasnip"
      "telescope-lazy-nvim"
      "telescope-live-grep-args-nvim"
      "cmp-nixpkgs"
      "easypick-nvim"
      "terminal-nvim"
      "browser-bookmarks-nvim"
      "middleclass-nvim"
      "nvim-devdocs"
    ]);
  getVimSources = prev: replaceDots (prev.callPackage (import ./_sources/generated.nix) { });
  vimPlugins = final: prev: let 
    vp = allVimPlugins prev (getVimSources final);
    up = final.vimPlugins;
  in vp // {
    nvim-devdocs = vp.nvim-devdocs.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
    };
    telescope-live-grep-args-nvim = vp.telescope-live-grep-args-nvim.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
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
    commander-nvim = vp.commander-nvim.overrideAttrs {
      dependencies = with up; [ telescope-nvim ];
    };
    telescope-undo = vp.telescope-undo.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
    };
    telescope-tabs = vp.telescope-tabs.overrideAttrs {
      dependencies = with up; [ plenary-nvim telescope-nvim ];
    };
    cmp-nixpkgs = vp.cmp-nixpkgs.overrideAttrs {
      dependencies = with up; [ nvim-cmp ];
    };
  };
  systems = [ "x86_64-linux" ];
in
{
  overlays = {
    vimPlugins = final: prev: {
      vimPluginsSources = getVimSources prev;
      vimPlugins = prev.vimPlugins // (vimPlugins final prev);
    };
  };

  vimPlugins = lib.genAttrs systems (system: vimPlugins (getPkgs system) (getPkgs system));
}
