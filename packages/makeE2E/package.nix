{
  strace,
  hello,
  zip,
  lib,
  findutils,
  stdenv,
}:
{
  compiler,
  languageVersion,
  virtualMachine,
  includej5 ? lib.compareVersions languageVersion "1.5" >= 0,
  includej6 ? lib.compareVersions languageVersion "1.6" >= 0,
}:
let
  filter =
    path: type:
    let
      name = lib.baseNameOf path;
    in
    (if name == "j5" then includej5 else type != "file" || lib.strings.hasSuffix ".java" name);
in
stdenv.mkDerivation {
  name = "${compiler.name}-${virtualMachine.name}-tests-${languageVersion}";
  src = lib.cleanSourceWith {
    inherit filter;
    src = ./.;
  };
  nativeBuildInputs = [
    compiler
    zip
    findutils
  ];
  buildInputs = [ ];
  checkInputs = [
    virtualMachine
    hello
    strace
  ];
  buildPhase = ''
    mkdir dist
    compiler=${lib.getExe compiler}
    if [[ -x "${compiler}/bin/javac" ]]; then
      compiler="${compiler}/bin/javac"
    fi
    "$compiler" -source ${languageVersion} -target ${languageVersion} -d dist $(find -name '*.java')
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
    for test in $(find . -name '*Test.java'); do
      echo Running $test
      ${lib.getExe virtualMachine} -cp tests.jar ''$(echo "$test" | tr / . | sed -e 's|\.\.||' -e 's|\.java||')
    done
  '';
  doCheck = true;
}
