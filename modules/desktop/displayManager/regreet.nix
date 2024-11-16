{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkForce getExe concatLines concatStringsSep optionalString mapAttrsToList types;
  cfg = config.modules.desktop.displayManager.regreet;

  homeCfgs = config.home-manager.users;
  extraDataPaths = concatStringsSep ":" (mapAttrsToList
    (n: _: "/nix/var/nix/profiles/per-user/${n}/${n}/home-path/share")
    homeCfgs);
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${extraDataPaths}"'';

  hyprland = inputs.desktop-flake.inputs.hyprland.packages.${pkgs.system}.hyprland;

  hyprland-kiosk = command:
    "${hyprland}/bin/Hyprland --config ${
      pkgs.writeText "hyprland.conf" ''
        animations:enabled = false

        cursor {
          inactive_timeout = 10
          no_hardware_cursors = true
        }

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

        ${concatLines (map (m:
          let
            resolution = "${toString m.width}x${toString m.height}@${
                toString m.refreshRate
              }";
            position = "${toString m.x}x${toString m.y}";
            scaling = builtins.toString m.scaling;
            transform = builtins.toString m.transform;
            bitdepth =
              if m.bitdepth == null then
                ""
              else ", bitdepth, ${builtins.toString m.bitdepth}";
            vrr =
              if m.vrr == 0 then
                ""
              else ", vrr, ${builtins.toString m.vrr}";
          in "monitor = ${m.name}, ${
            if m.primary then "${resolution}, ${position}, ${scaling}, transform, ${transform}${bitdepth}${vrr}" else "disable"
          }") config.modules.devices.monitors)}

        ${optionalString config.modules.system.nvidia.enable ''
          env = GDK_BACKEND=wayland,x11
          env = LIBVA_DRIVER_NAME,nvidia
          env = GBM_BACKEND,nvidia-drm
          env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        ''}

        exec = ${vars} ${command} -l debug; ${pkgs.hyprland}/bin/hyprctl dispatch exit
      ''
    }";
in
{
  options.modules.desktop.displayManager.regreet = {
    enable = mkEnableOption "Whether to enable ReGreet";
    autologin = {
      enable = mkEnableOption
        "Whether to automatically login to a default session";
      command = mkOption {
        type = types.str;
        default = "Hyprland";
        description = "The command to automatically login with";
      };
      user = mkOption {
        type = types.str;
        default = "stephen";
        description = "The user to automatically login as";
      };
    };
  };

  config = mkIf cfg.enable {
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
          icon_theme_name = mkForce config.modules.desktop.theme.gtk.iconTheme.name;
          theme_name = mkForce config.modules.desktop.theme.gtk.theme.name;
          cursor_theme_name = mkForce config.modules.desktop.cursor.name;
          font_name = mkForce "${config.modules.desktop.fonts.profiles.regular.family} 14";
        };
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session.command =
          hyprland-kiosk (getExe config.programs.regreet.package);
        initial_session = mkIf cfg.autologin.enable {
          command = cfg.autologin.command;
          user = cfg.autologin.user;
        };
      };
    };

    security.pam.services.greetd.enableGnomeKeyring =
      config.modules.services.keyring.enable;
  };
}
