{
  lib,
  fetchurl,
  stdenv,
  jikes,
  jamvm-14,
}:
stdenv.mkDerivation {
  name = "ant-bootstrap";
  src = fetchurl {
    url = "https://archive.apache.org/dist/ant/source/apache-ant-1.8.4-src.tar.gz";
    hash = "sha256-328Krt4lSdxDR7ly78gDbAGnN8qsVFuLpDohaHvFIec=";
  };
  postUnpack = ''
    substituteInPlace ./$sourceRoot/build.xml \
      --replace-fail 'depends="jars,test-jar"' 'depends="jars"'
  '';
  nativeBuildInputs = [
    jamvm-14
    jikes
  ];
  buildInputs = [ jamvm-14 ];
  JAVACMD = "${lib.getExe jamvm-14}";
  JAVAC = "${lib.getExe jikes}";
  ANT_OPTS = "-Dbuild.compiler=jikes -Djvm=jamvm";
  buildPhase = ''
    ./build.sh -Ddist.dir=./dist -Dbuild.compiler=jikes -Djvm=jamvm dist
  '';
  installPhase = ''
    ANT_HOME=$out ./build.sh install
  '';
}
