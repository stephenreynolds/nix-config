{ pkgs }:

builtins.listToAttrs (map (path: {
  name =
    "${builtins.replaceStrings [ ".nix" ] [ "" ] (builtins.baseNameOf path)}";
  value = import path { inherit pkgs; };
}) [ ./deadnix.nix ./statix.nix ])
