{ config, lib, pkgs, ... }:

let
  cfg = config.modules.dev.podman;
  dockerEnabled = config.virtualisation.docker.enable;
in {
  options.modules.dev.podman = {
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
      default = config.modules.system.nvidia.enable;
      description = "Enable use of NVidia GPUs from within podman containers";
    };
    distrobox = { enable = lib.mkEnableOption "Whether to enable Distrobox"; };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        autoPrune.enable = cfg.autoPrune.enable;
        dockerCompat = !dockerEnabled;
        dockerSocket.enable = !dockerEnabled;
        defaultNetwork.settings.dns_enabled = true;
      };

      containers.cdi.dynamic.nvidia.enable = cfg.enableNvidia;
    };

    hm.home.packages = lib.mkIf cfg.distrobox.enable [ pkgs.distrobox ];

    modules.system.persist.state.directories = [ "/var/lib/containers" ];
  };
}
