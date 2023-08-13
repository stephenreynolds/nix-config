{ lib, ... }:
let
  workspaces =
    (map toString (lib.range 1 9)) ++
    (map (n: "F${toString n}") (lib.range 1 12));
  directions = rec {
    left = "l"; right = "r"; up ="u"; down = "d";
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

      "SUPER, J, togglesplit"
      "SUPER, V, fullscreen, 1"
      "SUPERSHIFT, V, fullscreen, 0"
      "SUPER, F, togglefloating"
      "SUPERSHIFT, F, pin"

      "SUPER, U, pseudo"

      "SUPER, minus, splitratio, -0.25"
      "SUPERSHIFT, equal, splitratio, 0.3333333"

      "SUPER, G, togglegroup"
      "SUPER, apostrophe, changegroupactive, f"
      "SUPERSHIFT, apostrophe, changegroupactive, b"

      "SUPER, 0, togglespecialworkspace"
      "SUPERSHIFT, 0, movetoworkspace, special"

      "SUPER, S, exec, hyprctl dispatch cyclenext && hyprctl dispatch layoutmsg swapwithmaster"
      "SUPER, L, layoutmsg, orientationnext"
      "SUPERSHIFT, L, layoutmsg, orientationprev"

      "SUPER, mouse_down, workspace, m+1"
      "SUPER, mouse_up, workspace, m-1"
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
