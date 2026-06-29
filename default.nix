{
  system ? builtins.currentSystem,
}:
let
  sources = import ./sources.nix { inherit system; };
  pkgs = sources.pkgs;
  lib = pkgs.lib;
  callPackage =
    f: overrides:
    let
      f' = if lib.isFunction f then f else import f;
    in
    pkgs.callPackage f' ((builtins.intersectAttrs (lib.functionArgs f') autoArgs) // overrides);
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
  packages = loadDir ./packages;
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
