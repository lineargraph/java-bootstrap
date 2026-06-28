{
  lib,
  breakpointHook,
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
  patches = [ ./ant.patch ];
  nativeBuildInputs = [
    jamvm
    jikes
    breakpointHook
  ];
  buildInputs = [ jamvm ];
  JAVACMD = "${lib.getExe jamvm}";
  JAVAC = "${lib.getExe jikes}";
  ANT_OPTS = "-Dbuild.compiler=jikes -Djvm=jamvm";
  buildPhase = ''
    ./build.sh -Ddist.dir=./dist dist
  '';
  installPhase = ''
    ANT_HOME=$out ./build.sh install
  '';
}
