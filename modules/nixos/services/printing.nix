{ config, lib, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf;
  cfg = config.modules.services.printing;
in
{
  options.modules.services.printing = {
    enable = mkEnableOption "Enable printing service";
    drivers = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = "[ pkgs.hplip ]";
      description = "List of printer drivers to install";
    };
  };

  config = mkIf cfg.enable {
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
