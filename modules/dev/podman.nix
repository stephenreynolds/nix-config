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
    completions = {
      fish.enable = mkOption {
        type = types.bool;
        default = config.hm.programs.fish.enable;
        description = "Whether to enable Fish shell completions for Podman";
      };
    };
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
    };

    hardware.nvidia-container-toolkit.enable = cfg.enableNvidia;

    networking.firewall.trustedInterfaces = [ "podman1" ];

    boot.kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 80;
    };

    hm.home.packages = with pkgs; [
      (mkIf cfg.distrobox.enable distrobox)
      (mkIf cfg.docker-compose.enable docker-compose)
      dive
      podman-tui
    ];

    hm.xdg.dataFile = {
      "fish/vendor_completions.d/podman.fish" = {
        enable = cfg.completions.fish.enable;
        source = "${pkgs.podman}/share/fish/vendor_completions.d/podman.fish";
      };
      "fish/vendor_completions.d/podman-remote.fish" = {
        enable = cfg.completions.fish.enable;
        source = "${pkgs.podman}/share/fish/vendor_completions.d/podman-remote.fish";
      };
    };

    modules.system.persist.state = {
      directories = [ "/var/lib/containers" ];
      home.directories = [ ".local/share/containers" ];
    };
  };
}
