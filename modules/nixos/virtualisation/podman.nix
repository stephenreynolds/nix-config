{ config, lib, ... }:

let cfg = config.my.virtualisation.podman;
in {
  options.my.virtualisation.podman = {
    enable = lib.mkEnableOption "Whether to enable Podman";
    autoPrune = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to periodically prune Podman resources";
      };
    };
    enableNvidia = lib.mkOption {
      type = lib.types.bool;
      default = config.my.system.nvidia.enable;
      description = "Enable use of NVidia GPUs from within podman containers";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = cfg.autoPrune.enable;
      enableNvidia = cfg.enableNvidia;
    };
  };
}
