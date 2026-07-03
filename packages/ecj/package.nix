{
  jikes,
  openjdk8_headless,
  jamvm,
  makeE2E,
  stdenv,
  ant-bootstrap,
  fetchFromGitHub,
  breakpointHook,
  unzip,
  xmlstarlet,
  moreutils,
  bash,
  lib,
}:
let
  ecjBare = stdenv.mkDerivation (finalAttrs: {
    pname = "ecj";
    withJikes = false;
    previousEcj = null;
    nativeBuildInputs = [
      jamvm
      ant-bootstrap
      xmlstarlet
      moreutils
      unzip
    ]
    ++ lib.optionals finalAttrs.withJikes [ jikes ]
    ++ lib.optionals (finalAttrs.previousEcj != null) [ finalAttrs.previousEcj ];
    srcJdt = fetchFromGitHub {
      name = "eclipse-jdt";
      owner = "eclipse-jdt";
      repo = "eclipse.jdt.core";
      rev = "f3fb33fde9b5fd8fd3021a7432912bb6fbeb17c7"; # JDK_1_5
      hash = "sha256-X6ACLma4sbBLNwi221CV3hG7lDIHD9FaArGK7ybWQD0=";
    };
    srcs = [
      finalAttrs.srcJdt
      (fetchFromGitHub {
        name = "eclipse-platform-resources";
        owner = "eclipse-platform";
        repo = "eclipse.platform.resources";
        rev = "v20040624a";
        hash = "sha256-TkyFY6QcPGbbBs+F+sAlg+DfIHgI/kWo68Glo7H9L9c=";
      })
      (fetchFromGitHub {
        name = "eclipse-platform-runtime";
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
        name = "eclipse-equinox";
        owner = "eclipse-equinox";
        repo = "equinox";
        rev = "c6557fef063db7fbf02744824849517ba641c56a";
        hash = "sha256-Q7VhfAZGsDSW5imKGgQoIMHZFbFyGITn1oJbYoMhqCg=";
      })
      (fetchFromGitHub {
        name = "eclipse-platform-text";
        owner = "eclipse-platform";
        repo = "eclipse.platform.text";
        rev = "v20040625_1200";
        hash = "sha256-kHpLTc2dwfIq37tO/FgmLQJLcG1YlDUsrNhztRuLEzA=";
      })
    ];
    sourceRoot = "ecj-source";
    zippedSourceProjects = [
      "org.eclipse.osgi.services"
      "org.eclipse.osgi.util"
    ];
    zippedSourceProjectsStr = lib.strings.join " " finalAttrs.zippedSourceProjects;
    unpackPhase = builtins.readFile ./unpacker.sh;
    JAVACMD = "${jamvm}/bin/jamvm";
    configurePhase = ''
      runHook preConfigure

      cat ${./header.xml} > build.xml
      for project in org.eclipse.* org.osgi.*; do
        if [[ -f "$project"/.classpath ]]; then
          classpath="$((xmlstarlet sel -t -v "//*[@kind='src' and not(@output) and not(starts-with(@path, '/'))]/@path" "$project"/.classpath || true) \
            | sed 's|.*|''${base}@PROJECT@/\0|' | tr '\n' :)"
          files="$(echo "$classpath" | tr : '\n' |
            sed 's|.*|<fileset dir="\0"><include name="**/*.rsc"/><include name="**/*.properties"/></fileset>|g' | tr '\n' ' ')"
          dependencies="$(((xmlstarlet sel -t -v "//project/text()" "$project"/.project || true) \
            | (grep -E "^($(ls | xargs | tr ' ' '|'))\$" || true); echo prepare) | xargs | tr ' ' ,)"
          sed -e "s|@DEPENDENCIES@|$dependencies|g" -e "s|@FILES@|$files|g" -e "s|@CLASSPATH@|$classpath|g" ${./project.xml} | sed -e "s|@PROJECT@|$project|g" >> build.xml
        fi
      done
      cat ${./footer.xml} >> build.xml

      if $stripSourcePath; then
        sed 's|sourcepath=""||g' -i build.xml
      fi

      runHook postConfigure
    '';
    stripSourcePath = finalAttrs.previousEcj != null;
    javaVersion = "1.4";
    antFlags =
      lib.optionals finalAttrs.withJikes [
        "-Dbuild.compiler=jikes"
        "-Dbuild.compiler.exe=jikes"
      ]
      ++ lib.optionals (finalAttrs.previousEcj != null) [
        "-Dbuild.compiler=extJavac"
        "-Dbuild.compiler.exe=${lib.getExe finalAttrs.previousEcj}"
      ]
      ++ [
        "-DjVersion=${finalAttrs.javaVersion}"
      ];
    antTarget = "org.eclipse.jdt.core";
    buildPhase = ''
      runHook preBuild

      ant ${lib.strings.join " " finalAttrs.antFlags} $antTarget

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r build/lib $out
      mkdir $out/bin
      echo '#!${bash}/bin/bash' >> $out/bin/ecj
      echo "${jamvm}/bin/jamvm -cp '$(find $out/lib/ | xargs | tr ' ' ':')' org.eclipse.jdt.internal.compiler.batch.Main" '"$@"' >> $out/bin/ecj
      chmod +x $out/bin/ecj

      runHook postInstall
    '';
    meta = {
      description = "The Eclipse Java Compiler";
      mainProgram = "ecj";
    };
  });

  ecjVersions = rec {
    ecj501 = ecjBare.overrideAttrs (
      final: prev: {
        version = "0.501";
        patches = [
          ./ecj.patch
        ];
        withJikes = true;
      }
    );
    ecjR3_3 = ecjBare.overrideAttrs (
      final: prev: {
        previousEcj = ecj501;
        version = "3.3";
        patches = [
          ./ecj33.patch
        ];
        srcJdt = fetchFromGitHub {
          name = "eclipse-jdt";
          owner = "eclipse-jdt";
          repo = "eclipse.jdt.core";
          rev = "R3_3";
          hash = "sha256-6bbi/IqI8LaW0CfF6nTDTZDD56zWNSGV6b4PBVyCtac=";
        };
        passthru.tests = {
          "ecj-1.6" = makeE2E {
            languageVersion = "1.6";
            virtualMachine = openjdk8_headless;
            compiler = final.finalPackage;
          };
        };
      }
    );
    ecj383 = ecjBare.overrideAttrs (
      # this is me being dumb and building an _older_ ecj version
      final: prev: {
        previousEcj = ecj501;
        version = "0.383";
        patches = [
          ./ecj2.patch
        ];
        javaVersion = "1.5";
        srcJdt = fetchFromGitHub {
          name = "eclipse-jdt";
          owner = "eclipse-jdt";
          repo = "eclipse.jdt.core";
          rev = "v_382a";
          hash = "sha256-Kdes4eso3DIfDjblJ60nfg+Vyj9Gmh7F7AkHQqDcex0=";
        };
      }
    );
    latest = ecjR3_3;
  };
in
ecjVersions.latest.overrideAttrs (
  final: prev: {
    passthru.versions = ecjVersions;
  }
)
