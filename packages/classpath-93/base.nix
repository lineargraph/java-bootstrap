{
  stdenv,
  fetchurl,
  pkg-config,
  findutils,
  glib,
  zip,
  lib,
  hash,
  jikes,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "classpath";
  withEcj = null;
  withJikes = false;
  buildInputs = [
    glib
  ];
  nativeBuildInputs = [
    pkg-config
    findutils
    zip
  ]
  ++ lib.optionals finalAttrs.withJikes [
    jikes
  ]
  ++ lib.optionals (finalAttrs.withEcj != null) [ finalAttrs.withEcj ];
  configureFlags =
    lib.optional finalAttrs.withJikes "--with-jikes"
    #  ++ lib.optional (finalAttrs.withEcj != null) ""
    ++ [
      "--disable-plugin"
      "--disable-gtk-peer"
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
    inherit hash;
  };
  meta = {
    license = lib.licenses.gpl2Only;
  };
})
