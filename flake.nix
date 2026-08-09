{
  description = "Flake exporting a configured neovim package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };
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
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.platforms.all;
      packages = import ./packages { inherit inputs lib; };
      module = lib.modules.importApply ./module.nix { inherit inputs packages; };
      wrapper = wrappers.lib.evalModule module;
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
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
        inherit (packages.overlays) vimPlugins;
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
          vimPlugins = lib.recurseIntoAttrs packages.vimPlugins.${system};
          kraftnvim-minimal = self.packages.${system}.neovim.wrap {
            binName = "kraftnvim-minimal";
            settings.profile = "minimal";
          };
          kraftnvim-all-languages = self.packages.${system}.neovim.wrap {
            settings.languages.enableAll = true;
          };
          # d2 dependencies are huge, so not included in main
          kraftnvim-d2 = self.packages.${system}.neovim.wrap {
            settings.diagrams.d2 = true;
          };
        }
      );
      # home manager and nixos modules
      # `wrappers.neovim.enable = true`
      # You can set any of the options.
      # But that is how you enable it.
      nixosModules = {
        default = self.nixosModules.kraftnvim;
        kraftnvim = wrappers.lib.getInstallModule {
          name = "kraftnvim";
          value = module;
        };
      };
      homeModules = {
        default = self.homeModules.kraftnvim;
        # they produce generically importable modules
        kraftnvim = self.nixosModules.kraftnvim;
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
