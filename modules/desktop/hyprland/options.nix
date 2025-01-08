{ config, lib, ... }:

let
  inherit (lib) mkIf findSingle;
  cfg = config.modules.desktop.hyprland;
in
mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = lib.mkForce 5;
      gaps_out = lib.mkForce 10;
      gaps_workspaces = 50;
      border_size = 1;

      resize_on_border = true;
      no_focus_fallback = true;

      layout = "master";

      allow_tearing = config.modules.gaming.enable;

      # Fallback colors
      "col.active_border" = "rgba(0DB7D4FF)";
      "col.inactive_border" = "rgba(31313600)";

      snap = {
        enabled = true;
        border_overlap = true;
      };
    };

    input = {
      float_switch_override_focus = 0;
      follow_mouse = 2;
      kb_layout = "us";
      numlock_by_default = false;
    };

    cursor = {
      inactive_timeout = 10;
      default_monitor = (findSingle (m: m.primary) "DP-1" "DP-1"
        config.modules.devices.monitors).name;
      use_cpu_buffer = true;
    };

    decoration = {
      rounding = 10;
      rounding_power = 4;

      blur = {
        enabled = true;
        brightness = 1;
        contrast = 1;
        ignore_opacity = true;
        new_optimizations = true;
        noise = 1.0e-2;
        passes = 4;
        popups = true;
        size = 5;
        special = false;
        xray = true;
      };

      shadow = {
        ignore_window = true;
        range = 20;
        offset = "0 2";
        render_power = 2;
        color = "rgba(0000001A)";
      };
    };

    animations = {
      animation = [
        "windows, 1, 1, md3_decel, popin 60%"
        "border, 1, 10, default"
        "workspaces, 1, 1, fluent_decel, slide"
        "specialWorkspace, 1, 1, md3_decel, slidevert"
      ];
      bezier = [ "md3_decel, 0.05, 0.7, 0.1, 1" "fluent_decel, 0.1, 1, 0, 1" ];
    };

    dwindle = {
      force_split = 2; # Split right
      permanent_direction_override = true;
      preserve_split = true;
      pseudotile = true;
      special_scale_factor = 0.95;
    };

    master = {
      slave_count_for_center_master = 0;
      inherit_fullscreen = true;
      mfact = 0.6;
      new_status = "master";
      new_on_top = true;
      orientation = "right";
      special_scale_factor = 0.95;
    };

    binds = {
      allow_workspace_cycles = true;
      movefocus_cycles_fullscreen = true;
      workspace_back_and_forth = false;
    };

    group = {
      auto_group = true;
      insert_after_current = false;

      groupbar = {
        gradients = false;
        height = 0;
        render_titles = false;
      };
    };

    misc = {
      allow_session_lock_restore = true;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      enable_swallow = false;
      focus_on_activate = true;
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
      new_window_takes_over_fullscreen = 1;
      vfr = true;
    };
  };
}
