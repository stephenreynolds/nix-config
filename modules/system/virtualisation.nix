{ config, lib, ... }:
with lib;
let cfg = config.modules.system.virtualisation;
in {
  options.modules.system.virtualisation = {
    guest = {
      spice = mkEnableOption "Enable the Spice agent";
      qxl = mkEnableOption "Enable the QXL video driver";
      qemu = mkEnableOption "Whethes the system is a QEMU guest";
    };
  };

  config = mkMerge [
    (mkIf cfg.guest.spice { services.spice-vdagentd.enable = true; })

    (mkIf cfg.guest.qxl { services.xserver.videoDrivers = [ "qxl" ]; })

    (mkIf cfg.guest.qemu { services.qemuGuest.enable = true; })
  ];
}
