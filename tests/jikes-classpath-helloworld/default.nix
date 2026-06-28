{
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
  src = ./.;
  buildPhase = ''
    jikes Main.java
    zip ${finalAttrs.name}.jar *.class
  '';
  installPhase = ''
    mkdir $out
    cp ${finalAttrs.name}.jar $out
  '';
})
