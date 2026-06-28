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
  outputs = {
    shell = callPackage ./shell.nix { };
    treefmt-wrapper = callPackage ./treefmt-wrapper.nix { };
    # jikes = callPackage ./packages/jikes { };
    inherit pkgs lib;
  }
  // lib.pipe ./packages [
    builtins.readDir
    lib.attrNames
    (lib.map (name: {
      inherit name;
      value = callPackage "${./packages}/${name}" { };
    }))
    lib.listToAttrs
  ];
in
outputs
