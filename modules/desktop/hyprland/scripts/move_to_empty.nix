{ lib, pkgs, ... }:

let
  jq = lib.getExe pkgs.jq;
in
pkgs.writeShellScript "movetoempty" ''
  active=$(hyprctl activeworkspace -j) 
  monitor=$(echo "$active" | ${jq} -r ".monitorID")
  workspaces=$(hyprctl workspaces -j)
  workspaces_on_monitor=$(echo "$workspaces" | ${jq} -r "map(select(.monitorID == $monitor and .id != -99))")

  last_id=$(echo "$workspaces_on_monitor" | ${jq} -r "max_by(.id).id")
  should_move=$(echo "$active" | ${jq} -r ".id != $last_id or .windows > 1")
  if [[ $should_move == "true" ]]; then
    hyprctl --batch "dispatch movetoworkspace $last_id ; dispatch movetoworkspace r+1"
  fi
''
