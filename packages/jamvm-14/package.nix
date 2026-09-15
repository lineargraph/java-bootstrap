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
  classpath ? classpath-93,
  languageVersion ? "1.4",
}:
stdenv.mkDerivation (finalAttrs: {
  name = "jamvm-${languageVersion}";
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
  postInstall = ''
    mkdir -p $out/nix-support
    echo "export BOOTCLASSPATH=\"$out/share/jamvm/classes.zip:$out/lib/rt.jar\"" > $out/nix-support/setup-hook
  '';
  passthru.tests = {
    "jikes" = makeE2E {
      languageVersion = "1.4";
      virtualMachine = finalAttrs.finalPackage;
      compiler = jikes;
    };
    "ecj" = makeE2E {
      inherit languageVersion;
      virtualMachine = finalAttrs.finalPackage;
      compiler = ecj.withJvm finalAttrs.finalPackage;
    };
    "ecj-1.3" = makeE2E {
      languageVersion = "1.3";
      virtualMachine = finalAttrs.finalPackage;
      compiler = ecj.withJvm finalAttrs.finalPackage;
    };
    "openjdk8" = makeE2E {
      inherit languageVersion;
      virtualMachine = finalAttrs.finalPackage;
      compiler = openjdk8_headless;
    };
  };
  meta = {
    licenses = lib.licenses.gpl2Only;
    mainProgram = "jamvm";
  };
})
