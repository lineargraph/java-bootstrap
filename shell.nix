{
  gdb,
  mkShell,
  just,
  treefmt-wrapper,
  cntr,
  nix-fast-build,
}:
mkShell {
  packages = [
    treefmt-wrapper
    cntr
    just
    nix-fast-build
    gdb
  ];
}
