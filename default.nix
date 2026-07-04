{
  system ? builtins.currentSystem,
}:
let
  sources = import ./sources.nix { inherit system; };
  pkgs = sources.pkgs;
  lib = pkgs.lib;
  callPackage = lib.callPackageWith (pkgs // autoArgs);
  autoArgs = outputs // sources;
  packages = lib.filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./packages;
  };
  outputs = {
    shell = callPackage ./shell.nix { };
    treefmt-wrapper = callPackage ./treefmt-wrapper.nix { };
    inherit
      pkgs
      lib
      packages
      callPackage
      ;
    checks = outputs.collectChecks packages;
  }
  // packages;
in
outputs
