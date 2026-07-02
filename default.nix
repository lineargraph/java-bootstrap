{
  system ? builtins.currentSystem,
}:
let
  sources = import ./sources.nix { inherit system; };
  pkgs = sources.pkgs;
  lib = pkgs.lib;
  callPackage = lib.callPackageWith (pkgs // autoArgs);
  autoArgs = outputs // sources;
  loadDir =
    dir:
    lib.pipe dir [
      builtins.readDir
      lib.attrNames
      (lib.map (name: {
        inherit name;
        value = callPackage "${dir}/${name}" { };
      }))
      lib.listToAttrs
    ];
  packages = lib.filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./packages;
  };
  tests = loadDir ./tests;
  outputs = {
    shell = callPackage ./shell.nix { };
    treefmt-wrapper = callPackage ./treefmt-wrapper.nix { };
    inherit
      pkgs
      lib
      packages
      tests
      ;
    checks = packages // tests;
  }
  // packages;
in
outputs
