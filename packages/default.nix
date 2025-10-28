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
      "browser-bookmarks-nvim"
      "commander-nvim"
      "easypick-nvim"
      "fm-nvim"
      "magma-nvim"
      "middleclass-nvim"
      "neozoom-nvim"
      "nvim-devdocs"
      "nvim-guess-indent"
      "nvim-telescope-hop"
      "one-small-step-for-vimkind-nvim"
      "portal-nvim"
      "quickselect-nvim"
      "sessions-nvim"
      "telescope-all-recent"
      "telescope-changes"
      "telescope-env"
      "telescope-lazy-nvim"
      "telescope-live-grep-args-nvim"
      "telescope-luasnip"
      "telescope-menufacture"
      "telescope-tabs"
      "telescope-undo"
      "terminal-nvim"
      "vim-doge"
    ]) // {
      gitlinker-nvim = nixpkgs.vimUtils.buildVimPlugin (
        sources.gitlinker-nvim // {
          version = builtins.substring 0 8 sources.gitlinker-nvim.version;
          dependencies = [ nixpkgs.vimPlugins.plenary-nvim ];
          patchPhase = ''
            substituteInPlace spec_init.lua \
              --replace-fail \
              'os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"' \
              '"${nixpkgs.vimPlugins.plenary-nvim}"'
          '';
        }
      );
    };
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
