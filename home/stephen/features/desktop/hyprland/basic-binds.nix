{ inputs, lib, ... }:
let
  workspaces =
    (map toString (lib.range 1 9)) ++
    (map (n: "F${toString n}") (lib.range 1 12));
  directions = rec {
    left = "l"; right = "r"; up ="u"; down = "d";
  };
in
{
  imports = [ inputs.hyprland.homeManagerModules.default ];

  wayland.windowManager.hyprland.extraConfig = let
    mainMod = "SUPER";
  in ''
  '';
}
