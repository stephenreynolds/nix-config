{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.dev.docker;
in
{
  options.modules.dev.docker = {
    enable = mkEnableOption "Whether to enable Docker";
    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to periodically prune Podman resources";
      };
    };
    enableNvidia = mkOption {
      type = types.bool;
      default = config.modules.system.nvidia.enable;
      description = "Enable use of NVidia GPUs from within podman containers";
    };
    enableOnBoot = mkEnableOption "Whether to start dockerd on boot";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = cfg.enableOnBoot;
        autoPrune.enable = cfg.autoPrune.enable;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };

      containers.cdi.dynamic.nvidia.enable = cfg.enableNvidia;
    };

    modules.system.persist.state = {
      directories = [ "/var/lib/containers" ];
      home.directories = [ ".local/share/containers" ];
    };
  };
}
