{ config, lib, pkgs, ... }:

let
  cfg = config.my.virtualisation;
in
{
  options.my.virtualisation = {
    host = {
      enable = lib.mkEnableOption "Enable libvirtd for hosting virtual machines";
      swtpm = lib.mkOption {
        type = lib.types.bool;
        default = cfg.host.enable;
        description = "Enable swtpm for QEMU";
      };
      spiceUSBRedirection = lib.mkOption {
        type = lib.types.bool;
        default = cfg.host.enable;
        description = "Enable USB redirection for Spice";
      };
    };
    guest = {
      spice = lib.mkEnableOption "Enable the Spice agent";
      qxl = lib.mkEnableOption "Enable the QXL video driver";
      qemu = lib.mkEnableOption "Whether the system is a QEMU guest";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.host.enable {
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

      users.groups.libvirtd = { };

      services.spice-vdagentd.enable = true;

      programs.virt-manager.enable = true;

      environment.systemPackages = with pkgs; [
        virt-viewer
        spice
        spice-gtk
        spice-protocol
      ];

      programs.dconf.enable = true;
    })

    (lib.mkIf cfg.guest.spice { services.spice-vdagentd.enable = true; })

    (lib.mkIf cfg.guest.qxl { services.xserver.videoDrivers = [ "qxl" ]; })

    (lib.mkIf cfg.guest.qemu { services.qemuGuest.enable = true; })
  ];
}
