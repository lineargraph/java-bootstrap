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
}:
(callPackage ./base.nix { hash = "sha256-3y0JNhKr0j/mfpQJ2JuyqOebFmT+Ky2kDhyO1pPjKUU="; })
.overrideAttrs
  (
    final: prev: {
      withJikes = true;
      version = "0.93";
      patches = [ ./classpath93.patch ];
    }
  )
