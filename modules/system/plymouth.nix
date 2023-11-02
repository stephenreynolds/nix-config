{ config, lib, ... }:
with lib;
let cfg = config.modules.system.plymouth;
in {
  options.modules.system.plymouth = {
    enable = mkEnableOption "Enable Plymouth for boot splash screen";
    theme = mkOption {
      type = types.str;
      default = "breeze";
      description = "Plymouth theme to use";
    };
  };

  config = mkIf cfg.enable {
    console = {
      useXkbConfig = true;
      earlySetup = false;
    };

    boot = {
      plymouth = {
        enable = true;
        theme = cfg.theme;
      };
      loader.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
