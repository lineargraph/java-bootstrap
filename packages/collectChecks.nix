{ lib }:
let
  collectChecks' =
    root:
    if lib.isDerivation root then
      [
        {
          value = root;
          path = [ ];
        }
      ]
      ++ collectChecks' root.passthru
    else if lib.isAttrs root then
      lib.pipe root [
        lib.attrsToList
        (lib.concatMap (
          parent:
          lib.map (child: {
            value = child.value;
            path = [ parent.name ] ++ child.path;
          }) (collectChecks' parent.value)
        ))
      ]
    else
      [ ];
in
root:
lib.pipe root [
  collectChecks'
  (lib.map (
    { path, value }: {
      inherit value;
      name = lib.join "." path;
    }
  ))
  lib.listToAttrs
]
