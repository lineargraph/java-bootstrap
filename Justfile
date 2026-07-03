build-all:
    nix-fast-build --file default.nix -A checks

repl:
    nix repl --file default.nix

clean:
    rm -f result* repl-result*
