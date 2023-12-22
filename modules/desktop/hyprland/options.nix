{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  colorscheme = config.modules.desktop.theme.colorscheme;
in
lib.mkIf cfg.enable {
  hm.wayland.windowManager.hyprland.settings = lib.mkMerge [{
    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
      gaps_in = 4;
      gaps_out = 8;
      gaps_workspaces = 50;

      border_size = 1;

      layout = "dwindle";

      resize_on_border = true;

      cursor_inactive_timeout = 10;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "us";
      follow_mouse = 1;
      float_switch_override_focus = 0;
      numlock_by_default = true;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;

      blur = {
        enabled = true;
        size = 10;
        passes = 4;
        ignore_opacity = true;
        new_optimizations = true;
        xray = true;
        noise = 0.0117;
        contrast = 1;
        special = false;
      };

      drop_shadow = true;
      shadow_range = 15;
      shadow_render_power = 6;
      shadow_offset = "0 2";
      "col.shadow" = "rgba(00000044)";
      "col.shadow_inactive" = "0x66000000";
    };

    # https://wiki.hyprland.org/Configuring/Animations/
    animations = {
      animation = [
        "windows, 0, 1, md3_decel, popin 60%"
        "border, 0, 10, default"
        "fade, 0, 1, md3_decel"
        "workspaces, 0, 1, easeOutExpo, slide"
        "specialWorkspace, 0, 1, md3_decel, slidevert"
      ];
      bezier = [
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
      ];
    };

    # https://wiki.hyprland.org/Configuring/Dwindle-Layout/#config
    dwindle = {
      no_gaps_when_only = 0;
      pseudotile = true;
      preserve_split = true;
      permanent_direction_override = true;
      force_split = 2; # Split right
      special_scale_factor = 0.95;
    };

    # https://wiki.hyprland.org/Configuring/Master-Layout/#config
    master = {
      no_gaps_when_only = 0;
      mfact = 0.55;
      new_is_master = true;
      new_on_top = true;
      orientation = "left";
      inherit_fullscreen = true;
      always_center_master = true;
      special_scale_factor = 0.95;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#binds
    binds = {
      workspace_back_and_forth = true;
      allow_workspace_cycles = true;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#group
    group = {
      insert_after_current = false;

      groupbar = {
        render_titles = false;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      focus_on_activate = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      allow_session_lock_restore = true;
      enable_swallow = false;
      swallow_regex = "^(kitty)$";
      new_window_takes_over_fullscreen = 1;
    };
  }

    (lib.mkIf (colorscheme != null) {
      general = {
        "col.active_border" = "0xff${colorscheme.colors.base0A}";
        "col.inactive_border" = "0xff${colorscheme.colors.base03}";
        "col.nogroup_border_active" = "0xff${colorscheme.colors.base03}";
      };

      group = {
        "col.border_active" = "0xff${colorscheme.colors.base0A}";
        "col.border_inactive" = "0xff${colorscheme.colors.base03}";
        "col.border_locked_active" = "0xff${colorscheme.colors.base08}";
        "col.border_locked_inactive" = "0xff${colorscheme.colors.base03}";

        groupbar = {
          "col.active" = "0xff${colorscheme.colors.base0A}";
          "col.inactive" = "0xff${colorscheme.colors.base03}";
          "col.locked_active" = "0xff${colorscheme.colors.base08}";
          "col.locked_inactive" = "0xff${colorscheme.colors.base03}";
        };
      };
    })];
}
