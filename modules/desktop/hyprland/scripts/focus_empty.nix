{ lib, pkgs, ... }:

let
  jq = lib.getExe pkgs.jq;
in
pkgs.writeShellScript "focusempty" ''
  active=$(hyprctl activeworkspace -j)
  monitor=$(echo "$active" | ${jq} -r ".monitorID")
  workspaces=$(hyprctl workspaces -j)
  empty=$(echo "$active" | ${jq} -r ".windows == 0")
  if [[ $empty == "true" ]]; then
    workspaces_on_monitor=$(echo "$workspaces" | ${jq} -r "map(select(.monitorID == $monitor and .id != -99))")
    only_workspace=$(echo "$workspaces_on_monitor" | ${jq} -r "length == 1")
    if [[ $only_workspace == "false" ]]; then
      hyprctl dispatch workspace previous
    fi
  else
    id=$(echo "$workspaces" | ${jq} -r "max_by(.id).id + 1")
    hyprctl dispatch workspace $id
  fi
''
