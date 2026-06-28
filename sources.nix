{ system }:
let
  raw = import ./npins;
  nixpkgs = raw.nixpkgs { };
  nixpkgs' = import nixpkgs;
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ ];
  };
  appendOutpath =
    f: outPath:
    if pkgs.lib.isFunction f then
      appendOutpath { __functor = _: f; } outPath
    else
      f // { inherit outPath; };
  sources =
    pkgs.lib.mapAttrs (
      name: value:
      let
        outPath = value { inherit pkgs; };
      in
      appendOutpath (import outPath) outPath
    ) raw
    // {
      nixpkgs = appendOutpath nixpkgs' nixpkgs;
    };
in
sources
// {
  inherit
    sources
    raw
    pkgs
    ;
}
