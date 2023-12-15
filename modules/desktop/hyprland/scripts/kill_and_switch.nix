{ lib, pkgs, ... }:

let
  jq = lib.getExe pkgs.jq;
in
pkgs.writeShellScript "killandswitch" ''
    killactive() {
      case $(hyprctl activewindow -j | ${jq} -r ".class") in
        "discord")
          ${pkgs.xdotool}/bin/xdotool getactivewindow windowunmap
          hyprctl dispatch killactive ""
          ;;
        *)
          hyprctl dispatch killactive
      esac
    }

    workspace=$(hyprctl activewindow -j | ${jq} -r ".workspace.id")
    if [[ $workspace == "-99" ]]; then
      killactive
    else
      active=$(hyprctl activeworkspace -j)
      lastwindow=$(echo "$active" | ${jq} -r ".windows == 1")
      killactive
      if [[ $lastwindow == "true" ]]; then
        monitor=$(echo "$active" | ${jq} -r ".monitorID")
        lastworkspace=$(hyprctl workspaces -j | ${jq} -r "map(select(.monitorID == $monitor and .id != -99)) | length == 1")
        if [[ $lastworkspace == "false" ]]; then
          hyprctl dispatch workspace r-1
        fi
      fi
    fi
''
