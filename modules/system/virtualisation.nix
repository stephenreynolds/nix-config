{ config, lib, ... }:
with lib;
let cfg = config.modules.system.virtualisation;
in {
  options.modules.system.virtualisation = {
    host = {
      enable = mkEnableOption "Enable libvirtd for hosting virtual machines";
      swtpm = mkOption {
        type = types.bool;
        default = cfg.host.enable;
        description = "Enable swtpm for QEMU";
      };
      spiceUSBRedirection = mkOption {
        type = types.bool;
        default = cfg.host.enable;
        description = "Enable USB redirection for Spice";
      };
    };
    guest = {
      spice = mkEnableOption "Enable the Spice agent";
      qxl = mkEnableOption "Enable the QXL video driver";
      qemu = mkEnableOption "Whethes the system is a QEMU guest";
    };
  };

  config = mkMerge [
    (mkIf cfg.host.enable {
      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            swtpm.enable = cfg.host.swtpm;
            ovmf = {
              enable = true;
              packages = [ pkgs.OVMFFull.fd ];
            };
          };
        };
        spiceUSBRedirection.enable = cfg.host.spiceUSBRedirection;
      };

      services.spice-vdagentd.enable = true;

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
      ];

      programs.dconf.enable = true;
    })

    (mkIf cfg.guest.spice { services.spice-vdagentd.enable = true; })

    (mkIf cfg.guest.qxl { services.xserver.videoDrivers = [ "qxl" ]; })

    (mkIf cfg.guest.qemu { services.qemuGuest.enable = true; })
  ];
}
