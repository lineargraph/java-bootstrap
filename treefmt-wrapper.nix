{ pkgs, treefmt-nix }:
treefmt-nix.mkWrapper pkgs ./treefmt.nix
