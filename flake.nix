{
  description = "Flake exporting a configured neovim package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    # Demo on fetching plugins from outside nixpkgs
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    # These 2 are already in nixpkgs, however this ensures you always fetch the most up to date version!
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      packages = import ./packages { inherit inputs; lib = inputs.nixpkgs.lib; };
      module = nixpkgs.lib.modules.importApply ./module.nix { inherit inputs packages; };
      wrapper = wrappers.lib.evalModule module;
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "diagram.nvim" # doesn't have any license
          "terminal.nvim" # doesn't have any license
        ];
      };
    in
    # for demonstration purposes, we will set up all the outputs.
    {
      wrapperModules = {
        neovim = module;
        default = self.wrapperModules.neovim;
      };
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: prev: { neovim = self.wrappers.neovim.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
          vimPlugins = packages.vimPlugins.${system};
          minimal = self.packages.${system}.neovim.wrap {
            settings.dap.enable = false;
            settings.diagrams.enable = false;
            settings.docs.enable = false;
            settings.languages.lsp.enable = false;
            settings.languages.java.enable = false;
            settings.languages.rust.enable = false;
            settings.noice.enable = false;
            settings.snacks.startpage = false;
            settings.snippets.enable = false;
            settings.telescope.profile = "minimal";
          };
          # d2 dependencies are huge, so not included in main
          neovim-d2 = self.packages.${system}.neovim.wrap {
            settings.diagrams.d2 = true;
          };
        }
      );
      # home manager and nixos modules
      # `wrappers.neovim.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      nixosModules = {
        default = self.nixosModules.neovim;
        neovim = wrappers.lib.getInstallModule {
          name = "neovim";
          value = module;
        };
      };
      homeModules = {
        default = self.homeModules.neovim;
        # they produce generically importable modules
        neovim = self.nixosModules.neovim;
      };
      devShells = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShell {
            packages = [ pkgs.nvfetcher ];
            inputsFrom = [ ];
            shellHook = ''

            '';
          };
        }
      );
    };
}
