{
  stdenv,
  fetchurl,
  pkg-config,
  findutils,
  glib,
  zip,
  lib,
  jikes,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "0.93";
  patches = [ ./classpath93.patch ];
  pname = "classpath";
  buildInputs = [
    glib
  ];
  nativeBuildInputs = [
    pkg-config
    findutils
    zip
    jikes
  ];
  configureFlags = [
    "--with-jikes"
    "--disable-plugin"
    "--disable-gtk-peer"
    "--enable-default-preferences-peer=memory"
    "--disable-gconf-peer"
    # "--disable-examples"
    # "--enable-Werror"
  ];
  # postInstall = ''
  #   mkdir -p $out/nix-support
  #   echo "export BOOTCLASSPATH=$out/share/classpath/glibj.zip" > $out/nix-support/setup-hook
  # '';
  src = fetchurl {
    url = "mirror://gnu/classpath/classpath-${finalAttrs.version}.tar.gz";
    hash = "sha256-3y0JNhKr0j/mfpQJ2JuyqOebFmT+Ky2kDhyO1pPjKUU=";
  };
  meta = {
    license = lib.licenses.gpl2Only;
  };
})
