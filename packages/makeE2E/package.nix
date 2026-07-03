{
  strace,
  hello,
  zip,
  lib,
  stdenv,
}:
{
  compiler,
  languageVersion,
  virtualMachine,
}:
stdenv.mkDerivation {
  name = "${compiler.name}-${virtualMachine.name}-tests-${languageVersion}";
  src = ./.;
  nativeBuildInputs = [
    compiler
    zip
  ];
  buildInputs = [ ];
  checkInputs = [
    virtualMachine
    hello
    strace
  ];
  buildPhase = ''
    mkdir dist
    ${lib.getExe compiler} -d dist *.java
    (
      cd dist
      zip -r ../tests.jar .
    )
  '';
  installPhase = ''
    mkdir $out
    cp tests.jar $out
  '';
  checkPhase = ''
    for test in *Test.java; do
      echo Running $test
      ${lib.getExe virtualMachine} -cp tests.jar ''${test%.*}
    done
  '';
  doCheck = true;
}
