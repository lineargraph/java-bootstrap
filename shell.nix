{ mkShell, treefmt-wrapper }:
mkShell {
  packages = [ treefmt-wrapper ];
}
