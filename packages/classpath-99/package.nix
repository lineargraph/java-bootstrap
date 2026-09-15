{
  fetchurl,
  findutils,
  glib,
  lib,
  pkg-config,
  stdenv,
  zip,
  ecj,
  jamvm-14,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "classpath";
  version = "0.99";
  src = fetchurl {
    url = "mirror://gnu/classpath/classpath-${finalAttrs.version}.tar.gz";
    hash = "sha256-+Skpf4rpthOhoWfiMVZoYYkyYGUdkTrZtsEZM4lf7Mg=";
  };
  buildInputs = [
    glib
  ];
  nativeBuildInputs = [
    pkg-config
    findutils
    zip
    jamvm-14
    ecj
  ];
  configureFlags = [
    "--disable-plugin"
    "--disable-gtk-peer"
    "--enable-default-preferences-peer=memory"
    "--disable-gconf-peer"
    # "--disable-examples"
    # "--enable-Werror"
    # TODO: this is used for com.sun.tools.javac.Main, but will only load the jar itself, not the rest of the classpath
    "--with-ecj-jar=${ecj}/lib/org.eclipse.jdt.core.jar"
    # build with zip TODO: use previous classpath gjar?
    "--without-jar"
    # TODO: fix some stringop truncation errors
    "--disable-Werror"
    "--disable-gjdoc"
  ];
  patches = [
    ./classpath-99.patch
  ];
  ECJ_JVM_OPTS = "-Xmx3000m -Xss32m";
  meta = {
    license = lib.licenses.gpl2Only;
  };
})
