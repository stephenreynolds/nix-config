{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.desktop.hyprland;
  
  hycov = inputs.hycov.packages.${pkgs.system}.hycov;
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.plugins = [
    hycov
  ];

  hm.wayland.windowManager.hyprland.settings = {
    "plugin:hycov" = {
      overview_gappo = 60;
      overview_gappi = 24;
      enable_hotarea = false;
      disable_workspace_change = true;
      disable_spawn = true;
    };

    bind = [
      "SUPER, tab, hycov:toggleoverview"
    ];

    bindn = [
      ", return, hycov:leaveoverview"
      ", escape, hycov:leaveoverview"
    ];
  };
}
