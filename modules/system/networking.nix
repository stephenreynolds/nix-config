{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge mkDefault types optionalString;
  cfg = config.modules.system.networking;
in
{
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
    nftables.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use nftables instead of iptables";
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
    bpftune.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to automatically tune network parameters depending on workload";
    };
  };

  config = mkMerge [
    {
      networking = {
        firewall = {
          enable = cfg.firewall.enable;
        };
        nftables.enable = cfg.nftables.enable;
      };

      services.bpftune.enable = cfg.bpftune.enable;
    }

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

      modules.system.persist.state.directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
        (optionalString (cfg.networkManager.backend == "iwd") "/var/lib/iwd")
      ];
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

      networking = {
        firewall = {
          # if packets are still dropped, they will show up in dmesg
          logReversePathDrops = true;
          allowedUDPPorts = [ 51820 ];
        };
        nftables.ruleset = ''
          flush ruleset

          define pub_iface = "wlan0"
          define wg_port = 51820

          table inet filter {
              chain input {
                  type filter hook input priority 0; policy drop;

                  # accept all loopback packets
                  iif "lo" accept
                  # accept all icmp/icmpv6 packets
                  meta l4proto { icmp, ipv6-icmp } accept
                  # accept all packets that are part of an already-established connection
                  ct state vmap { invalid : drop, established : accept, related : accept }
                  # drop new connections over rate limit
                  ct state new limit rate over 1/second burst 10 packets drop

                  # accept all DHCPv6 packets received at a link-local address
                  ip6 daddr fe80::/64 udp dport dhcpv6-client accept
                  # accept all SSH packets received on a public interface
                  iifname $pub_iface tcp dport ssh accept
                  # accept all WireGuard packets received on a public interface
                  iifname $pub_iface udp dport $wg_port accept

                  # reject with polite "port unreachable" icmp response
                  reject
              }

              chain forward {
                  type filter hook forward priority 0; policy drop;
                  reject with icmpx type host-unreachable
              }
          }
        '';
      };
    })

    (mkIf cfg.optimizations.tcp.bbr {
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_mtu_probing" = 1;
      };
    })

    (mkIf cfg.optimizations.tcp.fastOpen {
      boot.kernel.sysctl = { "net.ipv4.tcp_fastopen" = 3; };
    })
  ];
}
