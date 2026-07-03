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
  collectChecks =
    root:
    lib.pipe root [
      (lib.collect lib.isDerivation)
      (lib.map (drv: [
        drv
        (lib.attrValues (collectChecks (drv.passthru or { })))
      ]))
      (lib.flatten)
      (lib.map (value: {
        inherit value;
        name = "check-" + value.name;
      }))
      lib.listToAttrs
    ];
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
    checks = collectChecks (packages // tests) // (lib.filterAttrs (_: lib.isDerivation) packages);
  }
  // packages;
in
outputs
