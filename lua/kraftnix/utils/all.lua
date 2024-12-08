return {
  helper = require 'kraftnix.utils.helper',
  lazy_nix = require 'kraftnix.utils.lazy_nix',
  telescope = {
    terminal = require 'kraftnix.utils.telescope.terminal',
    defaults = require 'kraftnix.utils.telescope.defaults',
    flake = require 'kraftnix.utils.telescope.flake',
  },
  keycommands = require 'kraftnix.utils.keycommands',
  vendor = {
    legendary = require 'kraftnix.utils.vendor.legendary',
    folke = require 'kraftnix.utils.vendor.folke',
    middleclass = require 'kraftnix.utils.vendor.middleclass',
  },
}
