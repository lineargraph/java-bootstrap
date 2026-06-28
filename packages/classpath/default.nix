{
  breakpointHook,
  fastjar,
  fetchurl,
  findutils,
  glib,
  jikes,
  lib,
  pkg-config,
  stdenv,
  zip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "classpath";
  version = "0.93";
  patches = [ ./classpath.patch ];
  buildInputs = [
    jikes
    findutils
    glib
  ];
  nativeBuildInputs = [
    pkg-config
    zip
    fastjar
    breakpointHook
  ];
  configureFlags = [
    "--disable-plugin"
    "--disable-gtk-peer"
    "--with-jikes"
    "--enable-default-preferences-peer=memory"
    "--disable-gconf-peer"
    # "--disable-examples"
    # "--enable-Werror"
  ];
  postInstall = ''
    mkdir -p $out/nix-support
    echo "export BOOTCLASSPATH=$out/share/classpath/glibj.zip" > $out/nix-support/setup-hook
  '';
  src = fetchurl {
    url = "mirror://gnu/classpath/classpath-${finalAttrs.version}.tar.gz";
    hash = "sha256-3y0JNhKr0j/mfpQJ2JuyqOebFmT+Ky2kDhyO1pPjKUU=";
  };
  meta = {
    license = lib.licenses.gpl2Only;
  };
})
