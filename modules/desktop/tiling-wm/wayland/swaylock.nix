{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.tiling-wm.wayland.swaylock;

  lockCommand = pkgs.writeShellScriptBin "lock" # bash
    ''
      cacheDir="$XDG_CACHE_HOME/swaylock"
      wallpaper=$(${
        lib.getExe pkgs.swww
      } query | awk -F'image: ' 'NR==1 {print $2}')
      bg="$cacheDir/$(basename "$wallpaper").jpg"

      if [ ! -f "$bg" ]; then
        mkdir "$cacheDir"
        ${pkgs.imagemagick}/bin/convert "$wallpaper" -blur 0x50 "$bg"
      fi

      ${lib.getExe cfg.package} --daemonize --image $bg
    '';
in {
  options.modules.desktop.tiling-wm.wayland.swaylock = {
    enable = lib.mkEnableOption "Whether to enable swaylock";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.swaylock-effects;
      description = "The swaylock package to use";
    };
    lockCommand = lib.mkOption {
      type = lib.types.package;
      default = lockCommand;
      description = "Command to run swaylock with";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.programs.swaylock = {
      enable = true;
      package = cfg.package;
      settings = {
        clock = true;
        ignore-empty-password = true;

        font = config.modules.desktop.fonts.profiles.regular.family;
        font-size = 15;

        effect-blur = "20x3";

        line-uses-inside = true;
        disable-caps-lock-text = true;
        indicator-caps-lock = true;
        indicator-idle-visible = true;

        indicator-radius = 100;
        indicator-thickness = 5;

        bs-hl-color = "d65d0e";
        ring-color = "7c6f64";
        ring-clear-color = "7c6f64";
        ring-caps-lock-color = "7c6f64";
        ring-ver-color = "7c6f64";
        ring-wrong-color = "7c6f64";
        key-hl-color = "ebdbb2";
        text-color = "fabd2f";
        text-clear-color = "fabd2f";
        text-caps-lock-color = "fabd2f";
        text-ver-color = "83a598";
        text-wrong-color = "fb4934";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        inside-color = "00000088";
        inside-clear-color = "00000088";
        inside-ver-color = "00000088";
        inside-wrong-color = "00000088";
        separator-color = "00000000";
      };
    };

    hm.home.packages = [ cfg.lockCommand ];

    security.pam.services.swaylock = { };
  };
}
