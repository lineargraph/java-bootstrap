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
  tests = lib.filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./tests;
  };
  outputs = {
    shell = callPackage ./shell.nix { };
    treefmt-wrapper = callPackage ./treefmt-wrapper.nix { };
    inherit
      pkgs
      lib
      packages
      tests
      callPackage
      ;
    checks = outputs.collectChecks (packages // { inherit tests; });
  }
  // packages;
in
outputs
