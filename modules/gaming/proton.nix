{ config, lib, pkgs, ... }:

let cfg = config.modules.gaming.proton;
in {
  options.modules.gaming.proton = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.gaming.enable;
      description = "Whether to enable Proton";
    };
    protontricks = {
      enable = lib.mkEnableOption "Whether to install Protontricks";
    };
    proton-ge = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Whether to install Proton GE";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hm.home.sessionVariables = {
        VKD3D_CONFIG = "dxr11,dxr";
        PROTON_ENABLE_NVAPI = 1;
        PROTON_ENABLE_NGX_UPDATER = 1;
        PROTON_HIDE_NVIDIA_GPU = 0;
      };
    }

    (lib.mkIf cfg.protontricks.enable {
      hm.home.packages = [ pkgs.protontricks ];
    })
  ]);
}
