{
  fetchurl,
  findutils,
  glib,
  jikes,
  lib,
  pkg-config,
  stdenv,
  zip,
  callPackage,
  ecj,
  jamvm,
}:

let
  classpath99 =
    (callPackage ../classpath-93/base.nix {
      hash = "sha256-+Skpf4rpthOhoWfiMVZoYYkyYGUdkTrZtsEZM4lf7Mg=";
    }).overrideAttrs
      (
        final: prev: {
          withEcj = ecj;
          patches = [ ./configure.patch ];
          nativeBuildInputs = prev.nativeBuildInputs ++ [
            jamvm
          ];
          configureFlags = prev.configureFlags ++ [
            # TODO: this is used for com.sun.tools.javac.Main, but will only load the jar itself, not the rest of the classpath
            "--with-ecj-jar=${ecj}/lib/org.eclipse.jdt.core.jar"
            # build with zip TODO: use previous classpath gjar?
            "--without-jar"
            # TODO: fix some stringop truncation errors
            "--disable-Werror"
            "--disable-gjdoc"
          ];
          version = "0.99";
          ECJ_JVM_OPTS = "-Xmx3000m -Xss32m";
        }
      );
in
classpath99
