{ config, lib, ... }:

let inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.modules.services.blocky;
in
{
  options.modules.services.blocky = {
    enable = mkEnableOption "Whether to enable Blocky";
    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };
    ports = {
      dns = mkOption {
        type = types.int;
        default = 53;
        description = "The the port the dns server will listen on";
      };
      http = mkOption {
        type = types.int;
        default = 4000;
        description = "The the port the web server will listen on";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.insertNameservers = [ cfg.address ];

    services.blocky = {
      enable = true;
      settings = {
        upstreams = {
          groups.default = [
            "https://dns.digitale-gesellschaft.ch/dns-query"
            "https://dns.quad9.net/dns-query"
          ];
          strategy = "parallel_best";
          timeout = "2s";
        };
        bootstrapDns = { upstream = "tcp+udp:9.9.9.9"; };
        blocking = {
          blackLists = {
            ads = [
              "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              "http://sysctl.org/cameleon/hosts"
              "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
            ];
            special = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts"
            ];
          };
          whiteLists.ads = [ ];
          clientGroupsBlock = {
            default = [ "ads" "special" ];
          };
          blockType = "nxDomain";
          blockTTL = "2h";
          loading = {
            refreshPeriod = "12h";
            strategy = "fast";
            downloads = {
              timeout = "60s";
              attempts = 5;
              cooldown = "1s";
            };
          };
        };
        filtering.queryTypes = [ "AAAA" ];
        caching = {
          minTime = "0m";
          maxTime = "0m";
          maxItemsCount = 0;
          prefetching = true;
          prefetchExpires = "2h";
          prefetchThreshold = 3;
          prefetchMaxItemsCount = 0;
          cacheTimeNegative = "90m";
        };
        ports = {
          dns = cfg.ports.dns;
          http = cfg.ports.http;
        };
        log = {
          level = "info";
          format = "text";
          timestamp = true;
          privacy = false;
        };
      };
    };
  };
}
