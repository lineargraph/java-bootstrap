{
  lib,
  breakpointHook,
  strace,
  vim,
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
  ]
  ++ [
    strace
    breakpointHook
    vim
  ];
  buildInputs = [ jamvm ];
  JAVACMD = "${lib.getExe jamvm}";
  JAVAC = "${lib.getExe jikes}";
  ANT_OPTS = "-Dbuild.compiler=jikes -Djvm=jamvm";
  buildPhase = ''
    ./build.sh -Ddist.dir=./dist -Dbuild.compiler=jikes -Djvm=jamvm dist
    exit 1
  '';
  installPhase = ''
    ANT_HOME=$out ./build.sh install
  '';
}
