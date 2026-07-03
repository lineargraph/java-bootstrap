{
  jamvm,
  zip,
  jikes,
  classpath,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "jikes-classpath-helloworld";
  nativeBuildInputs = [
    jikes
    zip
  ];
  buildInputs = [
    classpath
  ];
  checkInputs = [ jamvm ];
  checkPhase = ''
    jamvm -jar $out/*.jar
  '';
  src = ./.;
  buildPhase = ''
    jikes Main.java
    mkdir META-INF
    mv MANIFEST.MF META-INF
    zip ${finalAttrs.name}.jar *.class META-INF/MANIFEST.MF
  '';
  installPhase = ''
    mkdir $out
    cp ${finalAttrs.name}.jar $out
  '';
})
