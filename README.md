## Patching tutorial


``` sh
nix-shell . -A jamvm
unpackPhase
cd $sourceRoot
configurePhase
cp -r . ../a
# now we have a backup
patchPhase
# apply existing patches
# now make your changes and build using
buildPhase
# once you are done (or want to test in another drv)
# replace the paths here (especially the file filter)
git diff --no-relative -p --no-index a/ apache-ant-1.8.4 '*.xml' | sed -E -e '/index.*/d' -e '/diff.*/d' -e 's/([ab])\/[^/]+/\1/' | save -f packages/ant-bootstrap/ant.patch
```


