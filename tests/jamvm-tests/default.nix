{
  strace,
  hello,
  zip,
  stdenv,
  jikes,
  jamvm,
}:
stdenv.mkDerivation {
  name = "jamvm-tests";
  src = ./.;
  nativeBuildInputs = [
    jikes
    zip
  ];
  buildInputs = [ ];
  checkInputs = [
    jamvm
    hello
    strace
  ];
  buildPhase = ''
    mkdir dist
    jikes -sourcepath . -d dist *.java
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
      strace -f -e '!rt_sigprocmask' jamvm -cp tests.jar ''${test%.*}
    done
  '';
  doCheck = true;
}
