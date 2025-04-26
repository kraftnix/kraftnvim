{
  description = "Kraftnix's neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    systems = [ "x86_64-linux" "aarch64-linux" ];
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem systems;
    # will not apply to module imports
    extra_pkg_config = {
      # allowUnfree = true;
    };

    packages = import ./packages { inherit inputs; lib = inputs.nixpkgs.lib; };
    config = import ./config.nix (inputs // { inherit packages; });
    defaultPackageName = "kraftnvim";
    inherit (config) dependencyOverlays categoryDefinitions packageDefinitions;
  in
  # NOTE: BOILERPLATE BELOW
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    vimPlugins = packages.vimPlugins.${system};
    packages = utils.mkAllWithDefault defaultPackage;
    devShells.default = pkgs.mkShell {
      name = defaultPackageName;
      packages = [ defaultPackage pkgs.nvfetcher ];
      inputsFrom = [ ];
      shellHook = ''
      '';
    };
    checks = self.packages.${system} // self.vimPlugins.${system};
  }) // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName // packages.overlays;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    passthru = {
      inherit packageDefinitions categoryDefinitions luaPath defaultPackageName extra_pkg_config nixpkgs dependencyOverlays;
    };
    inherit (utils) templates;
  });
}
