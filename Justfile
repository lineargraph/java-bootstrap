build-all:
    nix-fast-build --file default.nix

repl:
    nix repl --file default.nix
