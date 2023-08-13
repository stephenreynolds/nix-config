{ lib, ... }:
let
  workspaces =
    (map toString (lib.range 0 9)) ++
    (map (n: "F${toString n}") (lib.range 1 12));
  directions = rec {
    left = "l"; right = "r"; up ="u"; down = "d";
    h = left; l = right; k = up; j = down;
  };
in
{
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    bind = [
      "SUPER, C, killactive"
      "SUPERSHIFT, E, exit"

      "SUPER, S, togglesplit"
      "SUPER, F, fullscreen, 1"
      "SUPERSHIFT, F, fullscreen, 0"
      "SUPERSHIFT, space, togglefloating"

      "SUPER, minus, splitratio, -0.25"
      "SUPERSHIFT, equal, splitratio, 0.3333333"

      "SUPER, G, togglegroup"
      "SUPER, apostrophe, changegroupactive, f"
      "SUPERSHIFT, apostrophe, changegroupactive, b"

      "SUPER, U, togglespecialworkspace"
      "SUPERSHIFT, U, movetoworkspace, special"
    ] ++
    # Change workspace
    (map (n:
      "SUPER, ${n}, workspace, name:${n}"
    ) workspaces) ++
    # Move window to workspace
    (map (n:
      "SUPERSHIFT, ${n}, movetoworkspace, name:${n}"
    ) workspaces) ++
    # Move window focus
    (lib.mapAttrsToList (key: direction:
      "SUPER, ${key}, movefocus, ${direction}"
    ) directions) ++
    # Swap windows
    (lib.mapAttrsToList (key: direction:
      "SUPERSHIFT, ${key}, swapwindow, ${direction}"
    ) directions) ++
    # Move monitor focus
    (lib.mapAttrsToList (key: direction:
      "SUPERCONTROL, ${key}, focusmonitor, ${direction}"
    ) directions) ++
    # Move window to monitor
    (lib.mapAttrsToList (key: direction:
      "SUPERCONTROLSHIFT, ${key}, movewindow, mon:${direction}"
    ) directions) ++
    # Move workspace to monitor
    (lib.mapAttrsToList (key: direction:
      "SUPERALT, ${key}, movecurrentworkspacetomonitor, ${direction}"
    ) directions);
  };
}
