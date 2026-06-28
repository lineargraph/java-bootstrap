{
  lib,
  breakpointHook,
  classpath,
  fetchurl,
  stdenv,
  jikes,
  jamvm,
}:
stdenv.mkDerivation {
  name = "ant-bootstrap";
  src = fetchurl {
    url = "https://archive.apache.org/dist/ant/source/apache-ant-1.8.4-src.tar.gz";
    hash = "sha256-328Krt4lSdxDR7ly78gDbAGnN8qsVFuLpDohaHvFIec=";
  };
  nativeBuildInputs = [
    jamvm
    jikes
    breakpointHook
  ];
  buildInputs = [ jamvm ];
  JAVACMD = "${lib.getExe jamvm}";
  JAVAC = "${lib.getExe jikes}";
  buildPhase = ''
    ./bootstrap.sh
    exit 1
  '';
}
