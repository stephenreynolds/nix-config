{ config, lib, ... }:

let cfg = config.modules.services.printing;
in {
  options.modules.services.printing = {
    enable = lib.mkEnableOption "Enable printing service";
    drivers = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = "[ pkgs.hplip ]";
      description = "List of printer drivers to install";
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = cfg.drivers;
      browsedConf = ''
        BrowseDNSSDSubTypes _cups,_print
        BrowseLocalProtocols all
        BrowseRemoteProtocols all
        CreateIPPPrinterQueues All

        BrowseProtocols all
      '';
    };

    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    programs.system-config-printer.enable = true;
  };
}
