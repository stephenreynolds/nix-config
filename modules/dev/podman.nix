{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.dev.podman;
  dockerEnabled = config.virtualisation.docker.enable;
in
{
  options.modules.dev.podman = {
    enable = mkEnableOption "Whether to enable Podman";
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
    distrobox = { enable = mkEnableOption "Whether to enable Distrobox"; };
    docker-compose = { enable = mkEnableOption "Whether to enable docker-compose"; };
  };

  config = mkIf cfg.enable {
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

    networking.firewall.trustedInterfaces = [ "podman1" ];

    hm.home.packages = [
      (mkIf cfg.distrobox.enable pkgs.distrobox)
      (mkIf cfg.docker-compose.enable pkgs.docker-compose)
    ];

    modules.system.persist.state = {
      directories = [ "/var/lib/containers" ];
      home.directories = [ ".local/share/containers" ];
    };
  };
}
