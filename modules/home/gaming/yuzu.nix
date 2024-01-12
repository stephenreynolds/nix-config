{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.my.gaming.yuzu;
in
{
  options.my.gaming.yuzu = {
    enable = mkEnableOption "Whether to install Yuzu";
    package = mkOption {
      type = types.package;
      default = pkgs.yuzu-mainline;
      defaultText = "pkgs.yuzu-mainline";
      description = "Yuzu package to install";
      relatedPackages = [ "yuzu-mainline" "yuzu-early-access" ];
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
