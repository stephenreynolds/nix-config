{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.gaming.yuzu;
in {
  options.modules.gaming.yuzu = {
    enable = mkEnableOption "Whether to install Yuzu";
    package = mkOption {
      type = types.package;
      default = pkgs.yuzu-mainline;
      defaultText = "pkgs.yuzu-mainline";
      description = "Yuzu package to install";
      relatedPackages = [ "yuzu-mainline" "yuzu-early-access" ];
    };
  };

  config = mkIf cfg.enable { hm.home.packages = [ cfg.package ]; };
}
