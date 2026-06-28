{
  breakpointHook,
  fetchurl,
  lib,
  zlib,
  stdenv,
  classpath,
  jikes,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "jamvm";
  version = "2.0.0";
  nativeBuildInputs = [
    breakpointHook
  ];
  buildInputs = [
    zlib
    classpath
  ];
  configureFlags = [
    "--with-java-runtime-library=gnuclasspath"
    "--with-classpath-install-dir=${classpath}"
  ];
  src = fetchurl {
    url = "mirror://sourceforge/project/jamvm/jamvm/JamVM%20${finalAttrs.version}/jamvm-${finalAttrs.version}.tar.gz";
    hash = "sha256-dkKOlt8K6d2WTHp8dMHpqDfi8xLDnpo1f6gXj37/gNo=";
  };
  postInstall = ''
    # ln -sf $BOOTCLASSPATH $out/lib/rt.jar
  '';
  meta = {
    licenses = lib.licenses.gpl2Only;
  };
})
