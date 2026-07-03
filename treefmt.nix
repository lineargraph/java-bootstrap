{
  programs.nixfmt.enable = true;
  programs.google-java-format = {
    enable = true;
    aospStyle = true;
    includes = [ "packages/*/*.java" ];
  };
}
