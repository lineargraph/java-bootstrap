{
  stdenv,
  fetchurl,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jikes";
  version = "1.22";
  src = fetchurl {
    url = "mirror://sourceforge/project/jikes/Jikes/${finalAttrs.version}/jikes-${finalAttrs.version}.tar.bz2";
    hash = "sha256-DLAsdjvEQTSfbTjKzVKt92IwLM46COJp8fdfcm5uFOM=";
  };
  meta = {
    license = lib.licenses.ipl10;
    mainProgram = "jikes";
  };
})
