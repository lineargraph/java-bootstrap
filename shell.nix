{
  mkShell,
  just,
  treefmt-wrapper,
  nix-fast-build,
}:
mkShell {
  packages = [
    treefmt-wrapper
    just
    nix-fast-build
  ];
}
