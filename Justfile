build-all:
    nix-fast-build --file {{module_directory()}} -A checks

repl:
    nix repl --file {{module_directory()}}

clean:
    rm -f result* repl-result*

@preparePatch attr:
    #!/usr/bin/env nix-shell
    #! nix-shell {{module_directory()}} -A {{attr}} -i bash
    source $stdenv/setup
    chmod -fR +w patch-{{attr}}
    rm -fr patch-{{attr}}
    mkdir patch-{{attr}}
    cd patch-{{attr}}
    if test -z "$unpackPhase"; then
      unpackPhase
    else
      eval "$unpackPhase"
    fi
    mv "$sourceRoot" modified
    ( cd modified
      patchPhase
      configurePhase
    )
    cp -r modified backup
    ( cd backup
      patchPhase
    )

@formatPatch attr *filters:
    git diff --no-relative -p --no-index patch-{{attr}}/backup/ patch-{{attr}}/modified/ ':!*.orig' {{filters}} | sed -E -e '/index.*/d' -e '/diff.*/d' -e 's|([ab])/[^/]*/[^/]*|\1|'