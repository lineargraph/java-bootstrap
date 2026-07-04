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
  antlr3, # TODO: this is leaking java deps
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
            antlr3
          ];
          version = "0.99";
        }
      );
in
classpath99
