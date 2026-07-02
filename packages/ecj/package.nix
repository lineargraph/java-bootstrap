{
  breakpointHook,
  jikes,
  jamvm,
  stdenv,
  ant-bootstrap,
  fetchFromGitHub,
  openjdk25,
}:
stdenv.mkDerivation {
  pname = "ecj";
  version = "JDK_1_5";
  nativeBuildInputs = [
    jikes
    breakpointHook
    jamvm
    # openjdk25
    ant-bootstrap
  ];

  src = fetchFromGitHub {
    owner = "eclipse-jdt";
    repo = "eclipse.jdt.core";
    rev = "f3fb33fde9b5fd8fd3021a7432912bb6fbeb17c7";
    hash = "sha256-X6ACLma4sbBLNwi221CV3hG7lDIHD9FaArGK7ybWQD0=";
  };

  buildPhase = ''
    cd org.eclipse.jdt.core/scripts
    ant -f buildExtraJars.xml -Dbuild.compiler=jikes -Djvm=jamvm build
  '';
}
