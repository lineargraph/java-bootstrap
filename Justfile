build-all:
    nix-fast-build --file default.nix -A packages

repl:
    nix repl --file default.nix
