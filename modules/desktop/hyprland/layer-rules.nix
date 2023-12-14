{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/60-layer-rules.conf";
in
lib.mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    layerrule = xray 1, .*
  '';
}
