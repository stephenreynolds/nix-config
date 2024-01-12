{ config, lib, pkgs, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;
  cfg = config.my.gaming.proton;
in
{
  options.my.gaming.proton = {
    enable = mkOption {
      type = types.bool;
      default = config.my.gaming.enable;
      description = "Whether to enable Proton";
    };
    protontricks = {
      enable = mkEnableOption "Whether to install Protontricks";
    };
    proton-ge = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to install Proton GE";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.sessionVariables = {
        VKD3D_CONFIG = "dxr11,dxr";
        PROTON_ENABLE_NVAPI = 1;
        PROTON_ENABLE_NGX_UPDATER = 1;
        PROTON_HIDE_NVIDIA_GPU = 0;
      };
    }

    (mkIf cfg.protontricks.enable {
      home.packages = [ pkgs.protontricks ];
    })
  ]);
}
