# Kraftnix's neovim configuration

Uses [nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules) to generate Neovim configurations.
  - [nix-wrapper-modules Neovim Docs](https://birdeehub.github.io/nix-wrapper-modules/wrapperModules/neovim.html)
  - [lze plugin manager](https://github.com/BirdeeHub/lze)

## Exposed Configurations

There are multiple neovim configurations exposed from this flake:
  - `neovim`: full neovim profile for development
  - `neovim-minimal`: minimal neovim profile for servers / headless
  - `neovim-d2`: full neovim profile with d2 plugin (large dependencies)

Usage:
```sh
git clone https://github.com/kraftnix/kraftnvim ~/.config/kraftnvim-wip
KRAFTNVIM_NAME=kraftnvim-wip kraftnvimLocal
```

## Downstream Usage

Instructions on how to use this configuration in downstream ways.

### Direct Package

Run directly from this flake or add to packages.

```sh
nix run github:kraftnix/kraftnvim#kraftnvim
```

Add to devshell or package

```nix
{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.kraftnvim.packages.${pkgs.stdenv.hostPlatform.system}.kraftnvimStable
  ];
}
```

### Home Manager

## Extra Plugins

Extra vim plugins are fetched using `nvfetcher`.

All plugins are added to an overlay at `overlays.vimPlugins` and available as packages
at `packages.<system>.vimPlugins`

### Adding a new Plugin

Add an entry to [`sources.toml`](./packages/sources.toml) and add the plugin to the list at
the top of [`packages`](./packages/default.nix).

### Update `nvfetcher` Plugins

Uses `nvfetcher` to handle extra vimPlugins.

```sh
nvfetcher -c ./packages/sources.toml -o ./packages/_sources
```

## ToDo

- [ ] integrate nixCats splits of categories in lua plugin code
  - currently only splitting for adding plugins, which is ignored by lazy.nvim anyway
- [ ] investigate using `lze` for plugin loading instead of `lazy.nvim`
