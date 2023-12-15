{ lib, pkgs, ... }:

let
  jq = lib.getExe pkgs.jq;
in
pkgs.writeShellScript "togglelayout" ''
  layout=$(hyprctl -j getoption general:layout | ${jq} -r ".str")
  if [[ $layout == "master" ]]; then
    hyprctl keyword general:layout "dwindle"
  else
    hyprctl keyword general:layout "master"
  fi
''
