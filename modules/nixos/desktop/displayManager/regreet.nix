{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.my.desktop.displayManager.regreet;

  homeCfgs = config.home-manager.users;
  extraDataPaths = lib.concatStringsSep ":" (lib.mapAttrsToList
    (n: _: "/nix/var/nix/profiles/per-user/${n}/${n}/home-path/share")
    homeCfgs);
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${extraDataPaths}"'';

  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;

  hyprland-kiosk = command: "${hyprland}/bin/Hyprland --config ${pkgs.writeText "hyprland.conf" ''
    general:cursor_inactive_timeout = 10
    animations:enabled = false

    decoration {
      blur:enabled = false
      drop_shadow = false
      rounding = 0
    }

    misc {
      disable_autoreload = true
      disable_hyprland_logo = true
      disable_splash_rendering = true
      force_default_wallpaper = 0
      background_color = 0x000000
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
    }

    input {
      kb_layout = us
      numlock_by_default = true
    }

    ${lib.concatLines (map
      (m:
        let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
        in
        "monitor = ${m.name}, ${if m.primary then "${resolution}, ${position}, 1" else "disable"}")
      config.my.devices.monitors)}

    ${lib.optionalString config.my.system.nvidia.enable ''
      env = GDK_BACKEND=wayland,x11
      env = LIBVA_DRIVER_NAME,nvidia
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
    ''}

    exec = ${vars} ${command} -l debug; ${pkgs.hyprland}/bin/hyprctl dispatch exit
  ''}";
in
{
  options.my.desktop.displayManager.regreet = {
    enable = lib.mkEnableOption "Whether to enable ReGreet";
    autologin = {
      enable = lib.mkEnableOption "Whether to automatically login to a default session";
      command = lib.mkOption {
        type = lib.types.str;
        default = "Hyprland";
        description = "The command to automatically login with";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "stephen";
        description = "The user to automatically login as";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.extraUsers.greeter.packages = [
      config.modules.desktop.theme.gtk.theme.package
      config.modules.desktop.theme.gtk.iconTheme.package
      config.modules.desktop.cursor.package
      config.modules.desktop.fonts.profiles.regular.package
    ];

    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          icon_theme_name = config.modules.desktop.theme.gtk.iconTheme.name;
          theme_name = config.modules.desktop.theme.gtk.theme.name;
          cursor_theme_name = config.modules.desktop.cursor.name;
          font_name = "${config.modules.desktop.fonts.profiles.regular.family} 14";
        };
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session.command = hyprland-kiosk (lib.getExe config.programs.regreet.package);
        initial_session = lib.mkIf cfg.autologin.enable {
          command = cfg.autologin.command;
          user = cfg.autologin.user;
        };
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = config.my.services.keyring.enable;
  };
}
