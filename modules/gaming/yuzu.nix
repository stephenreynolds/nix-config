{ config, lib, pkgs, ... }:

let cfg = config.modules.gaming.yuzu;
in {
  options.modules.gaming.yuzu = {
    enable = lib.mkEnableOption "Whether to install Yuzu";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.yuzu-mainline;
      defaultText = "pkgs.yuzu-mainline";
      description = "Yuzu package to install";
      relatedPackages = [ "yuzu-mainline" "yuzu-early-access" ];
    };
  };

  config = lib.mkIf cfg.enable { hm.home.packages = [ cfg.package ]; };
}
