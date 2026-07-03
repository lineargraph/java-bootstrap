{
  breakpointHook,
  jikes,
  jamvm,
  stdenv,
  ant-bootstrap,
  fetchFromGitHub,
  openjdk25,
  unzip,
  xmlstarlet,
  moreutils,
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
    xmlstarlet
    moreutils
    unzip
  ];
  srcs = [
    (fetchFromGitHub {
      owner = "eclipse-jdt";
      repo = "eclipse.jdt.core";
      rev = "f3fb33fde9b5fd8fd3021a7432912bb6fbeb17c7"; # JDK_1_5
      hash = "sha256-X6ACLma4sbBLNwi221CV3hG7lDIHD9FaArGK7ybWQD0=";
    })
    (fetchFromGitHub {
      owner = "eclipse-platform";
      repo = "eclipse.platform.resources";
      rev = "v20040624a";
      hash = "sha256-TkyFY6QcPGbbBs+F+sAlg+DfIHgI/kWo68Glo7H9L9c=";
    })
    (fetchFromGitHub {
      owner = "eclipse-platform";
      repo = "eclipse.platform.runtime";
      rev = "v20040625_1200";
      hash = "sha256-pVZjBZbvMtK3/AYGjOfjBDIRvPe18GKj8yWLRFcZVAE=";
    })
    #    (fetchFromGitHub {
    #      owner = "osgi";
    #      repo = "osgi";
    #      rev = "01111010ac6c558ca5f169afec32a39847858110";
    #      hash = "sha256-S+BDCRcie8gG4nzsGHo3Cx/orY9QP2Gw9XgdYD/H6/Y=";
    #    })
    (fetchFromGitHub {
      owner = "eclipse-equinox";
      repo = "equinox";
      rev = "c6557fef063db7fbf02744824849517ba641c56a";
      hash = "sha256-Q7VhfAZGsDSW5imKGgQoIMHZFbFyGITn1oJbYoMhqCg=";
    })
  ];
  patches = [
    ./ecj.patch
  ];
  sourceRoot = ".";
  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
      if [[ -d "$_src"/bundles ]]; then
        cp -r "$_src"/bundles/* .
      else
        cp -r "$_src"/* .
      fi
    done

    chmod -R u+w .

    runHook postUnpack
  '';
  JAVACMD = "${jamvm}/bin/jamvm";
  buildPhase = ''
    cp ${./services-classpath.xml} org.eclipse.osgi.services/.classpath
    mkdir org.eclipse.osgi.services/src
    (
      cd org.eclipse.osgi.services/src
      unzip ../servicessrc.zip
      rm -rf org/osgi/service/{jini,io,http}
    )

    cp ${./services-classpath.xml} org.eclipse.osgi.util/.classpath
    mkdir org.eclipse.osgi.util/src
    (
      cd org.eclipse.osgi.util/src
      unzip ../utilsrc.zip
    )

    cat ${./header.xml} > build.xml
    for project in org.eclipse.* org.osgi.*; do
      if [[ -f "$project"/.classpath ]]; then
        echo "Loading project $project"
        cat "$project/.classpath"
        classpath="$((xmlstarlet sel -t -v "//classpathentry[@kind='src']/@path" "$project"/.classpath || true) \
          | sed 's|.*|''${base}@PROJECT@/\0|' | tr '\n' :)"
        echo "classpath: $classpath"
        dependencies="$(((xmlstarlet sel -t -v "//project/text()" "$project"/.project || true) \
          | (grep -E "^($(ls | xargs | tr ' ' '|'))\$" || true); echo prepare) | xargs | tr ' ' ,)"
        sed -e "s|@DEPENDENCIES@|$dependencies|g" -e "s|@CLASSPATH@|$classpath|g" ${./project.xml} | sed -e "s|@PROJECT@|$project|g" >> build.xml
        sed -e "s|@DEPENDENCIES@|$dependencies|g" -e "s|@CLASSPATH@|$classpath|g" ${./project.xml} | sed -e "s|@PROJECT@|$project|g"
      fi
    done
    cat ${./footer.xml} >> build.xml
    cat build.xml
    for srcFile in $(find . -type f -name '*.java'); do
      # Can i avoid iconv'ing _everything_?
      (iconv -f cp1250 -t utf8 "$srcFile" || continue) | sponge "$srcFile"
    done
    ant org.eclipse.core.runtime
  '';
  installPhase = ''
    mkdir $out
    cp -r build/lib $out
  '';
}
