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

```shell
nea@hadante java-bootstrap λ ls -lah
total 116K
drwxr-xr-x 1 nea users 1.3K Jul  4 02:33  .
drwxr-xr-x 1 nea  1000  14K Jul  3 21:16  ..
drwxr-xr-x 1 nea users   38 Jul  3 18:48  .claude
-rw-r--r-- 1 nea users 1.2K Jul  3 19:05  default.nix
drwxr-xr-x 1 nea users  316 Jul  3 18:38  .direnv
-rw-r--r-- 1 nea users   29 Jul  3 18:38  .envrc
drwxr-xr-x 1 nea users  188 Jul  4 02:34  .git
-rw-r--r-- 1 nea users   45 Jul  3 14:44  .gitignore
drwxr-xr-x 1 nea users  288 Jul  4 02:31  .idea
drwxr-xr-x 1 nea users   52 Jun 26 22:49  .jj
-rw-r--r-- 1 nea users  908 Jul  3 23:59  Justfile
drwxr-xr-x 1 nea users   46 Jul  2 20:27  npins
drwxr-xr-x 1 nea users  122 Jul  3 19:12  packages
drwxr-xr-x 1 nea users   28 Jul  4 02:33  patch-ecj
-rw-r--r-- 1 nea users  502 Jun 30 20:06  README.md
lrwxrwxrwx 1 nea users   57 Jul  4 00:25  result-ant-bootstrap -> /nix/store/nsbm5zygvrvm43qjhnf5wy0dpj0niilv-ant-bootstrap
lrwxrwxrwx 1 nea users   57 Jul  4 00:25  result-check-ant-bootstrap -> /nix/store/nsbm5zygvrvm43qjhnf5wy0dpj0niilv-ant-bootstrap
lrwxrwxrwx 1 nea users   58 Jul  4 00:25 'result-"check-classpath-0.93"' -> /nix/store/8ln832yw2xqqwi6a6mym1zzjzi6vrn7x-classpath-0.93
lrwxrwxrwx 1 nea users   53 Jul  4 00:25 'result-"check-ecj-0.383"' -> /nix/store/n7mskfzhhgn5d1d4f1rdi8nryjk6m7qg-ecj-0.383
lrwxrwxrwx 1 nea users   53 Jul  4 00:25 'result-"check-ecj-0.501"' -> /nix/store/aa69ayn9wy86yl04y2j53z560zfqj8ny-ecj-0.501
lrwxrwxrwx 1 nea users   51 Jul  4 00:21 'result-"check-ecj-3.3"' -> /nix/store/q31r77bdxbcg2znvhgdyf6md1s0d3cld-ecj-3.3
lrwxrwxrwx 1 nea users   67 Jul  4 00:21 'result-"check-ecj-3.3-jamvm-tests-1.3"' -> /nix/store/wnvzdxa9g97482kawlx9sd8w060vxnd9-ecj-3.3-jamvm-tests-1.3
lrwxrwxrwx 1 nea users   67 Jul  4 00:21 'result-"check-ecj-3.3-jamvm-tests-1.5"' -> /nix/store/4yijx4hz8s67116dsy4al3i83hsng939-ecj-3.3-jamvm-tests-1.5
lrwxrwxrwx 1 nea users   49 Jul  4 00:25  result-check-jamvm -> /nix/store/r2vagazc4m2i4zy44ni2cpf70kahpqv6-jamvm
lrwxrwxrwx 1 nea users   54 Jul  4 00:25 'result-"check-jikes-1.22"' -> /nix/store/rgg3jf8w6bgg1mp66izbhxjg2dc3dfni-jikes-1.22
lrwxrwxrwx 1 nea users   70 Jul  4 00:25 'result-"check-jikes-1.22-jamvm-tests-1.4"' -> /nix/store/3wf11pmd6w6nqyll3988ydim0l25xx75-jikes-1.22-jamvm-tests-1.4
lrwxrwxrwx 1 nea users   70 Jul  4 00:25  result-check-jikes-classpath-helloworld -> /nix/store/00f4rj6zn8sxa3xwrqqnd0yvawgyz6aa-jikes-classpath-helloworld
lrwxrwxrwx 1 nea users   86 Jul  4 00:25 'result-"check-openjdk-headless-8u502-b01-jamvm-tests-1.6"' -> /nix/store/i2mzd2q6zfiazviikk8zmlb285f24ahn-openjdk-headless-8u502-b01-jamvm-tests-1.6
lrwxrwxrwx 1 nea users   51 Jul  4 00:25 'result-"check-zip-3.0"' -> /nix/store/xzfinwy4j977sbqv771d2m8zbp3l1z48-zip-3.0
lrwxrwxrwx 1 nea users   58 Jul  4 00:25  result-classpath-93 -> /nix/store/8ln832yw2xqqwi6a6mym1zzjzi6vrn7x-classpath-0.93
lrwxrwxrwx 1 nea users   51 Jul  4 00:25  result-classpath-99 -> /nix/store/xzfinwy4j977sbqv771d2m8zbp3l1z48-zip-3.0
lrwxrwxrwx 1 nea users   51 Jul  4 00:21  result-ecj -> /nix/store/q31r77bdxbcg2znvhgdyf6md1s0d3cld-ecj-3.3
lrwxrwxrwx 1 nea users   49 Jul  4 00:25  result-jamvm -> /nix/store/r2vagazc4m2i4zy44ni2cpf70kahpqv6-jamvm
lrwxrwxrwx 1 nea users   54 Jul  4 00:25  result-jikes -> /nix/store/rgg3jf8w6bgg1mp66izbhxjg2dc3dfni-jikes-1.22
-rw-r--r-- 1 nea users  173 Jun 28 22:37  shell.nix
-rw-r--r-- 1 nea users  628 Jun 28 21:03  sources.nix
drwxr-xr-x 1 nea users   52 Jul  3 17:10  tests
-rw-r--r-- 1 nea users  157 Jul  3 18:38  treefmt.nix
-rw-r--r-- 1 nea users   64 Jun 28 17:39  treefmt-wrapper.nix
```