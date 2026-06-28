{
  breakpointHook,
  fetchurl,
  lib,
  zlib,
  stdenv,
  classpath,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "jamvm";
  version = "1.5.1";
  nativeBuildInputs = [ ];
  patches = [
    ./jamvm.patch
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
    hash = "sha256-ZjiVvWnK86H9pq9e6oJj2Qpf01yo9MMuIhCsQQeIkBo=";
  };
  meta = {
    licenses = lib.licenses.gpl2Only;
  };
})
