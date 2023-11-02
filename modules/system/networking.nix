{ config, lib, ... }:
with lib;
let cfg = config.modules.system.networking;
in {
  options.modules.system.networking = {
    networkManager = {
      enable = mkEnableOption "Enable NetworkManager";
      backend = mkOption {
        type = types.enum [ "wpa_supplicant" "iwd" ];
        default = "iwd";
        description = "The backend to use for WiFi connections";
      };
      randomizeMac = mkEnableOption "Whether to randomize MAC address";
      wireguard-vpn = {
        enable = mkEnableOption "Whether to enable WireGuard VPN";
      };
    };
    firewall.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the firewall";
    };
    optimizations = {
      tcp = {
        bbr = mkOption {
          type = types.bool;
          default = true;
          description = "Enable TCP BBR congestion control";
        };
        fastOpen = mkOption {
          type = types.bool;
          default = true;
          description = "Enable TCP Fast Open";
        };
      };
    };
  };

  config = mkMerge [
    { networking.firewall.enable = cfg.firewall.enable; }

    (mkIf cfg.networkManager.enable {
      systemd.services.NetworkManager-wait-online.enable = false;

      networking.networkmanager = {
        enable = mkDefault true;
        wifi = {
          backend = cfg.networkManager.backend;
          macAddress =
            if cfg.networkManager.randomizeMac then "random" else "preserve";
        };
      };
    })

    (mkIf cfg.networkManager.wireguard-vpn.enable {
      sops.secrets.vpn-wg-nm = {
        sopsFile = ../sops/secrets.yaml;
        path = "/etc/NetworkManager/system-connections/vpn-wg.nmconnection";
        mode = "0600";
        owner = "root";
        group = "root";
        restartUnits = [ "NetworkManager.service" ];
      };

      networking.firewall = {
        # if packets are still dropped, they will show up in dmesg
        logReversePathDrops = true;
        # wireguard trips rpfilter up
        extraCommands = ''
          ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
          ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
        '';
        extraStopCommands = ''
          ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
          ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
        '';
      };
    })

    (mkIf cfg.optimizations.tcp.bbr {
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    })

    (mkIf cfg.optimizations.tcp.fastOpen {
      boot.kernel.sysctl = { "net.ipv4.tcp_fastopen" = 3; };
    })
  ];
}
