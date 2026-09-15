{
  fetchurl,
  lib,
  zlib,
  stdenv,
  classpath-93,
  makeE2E,
  jikes,
  ecj,
  openjdk8_headless,
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
    classpath-93
  ];
  configureFlags = [
    "--with-java-runtime-library=gnuclasspath"
    "--with-classpath-install-dir=${classpath-93}"
  ];
  src = fetchurl {
    url = "mirror://sourceforge/project/jamvm/jamvm/JamVM%20${finalAttrs.version}/jamvm-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZjiVvWnK86H9pq9e6oJj2Qpf01yo9MMuIhCsQQeIkBo=";
  };
  postInstall = ''
    mkdir -p $out/nix-support
    echo "export BOOTCLASSPATH=\"$out/share/jamvm/classes.zip:$out/lib/rt.jar\"" > $out/nix-support/setup-hook
  '';
  passthru.tests = {
    "jikes-1.5" = makeE2E {
      languageVersion = "1.4";
      virtualMachine = finalAttrs.finalPackage;
      compiler = jikes;
    };
    "ecj-1.5" = makeE2E {
      languageVersion = "1.5";
      virtualMachine = finalAttrs.finalPackage;
      compiler = ecj;
      includej5 = false;
    };
    "ecj-1.3" = makeE2E {
      languageVersion = "1.3";
      virtualMachine = finalAttrs.finalPackage;
      compiler = ecj;
    };
    "openjdk8-1.6" = makeE2E {
      languageVersion = "1.6";
      virtualMachine = finalAttrs.finalPackage;
      compiler = openjdk8_headless;
      includej5 = false;
    };
  };
  meta = {
    licenses = lib.licenses.gpl2Only;
    mainProgram = "jamvm";
  };
})
