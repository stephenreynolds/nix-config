{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  colorscheme = config.modules.desktop.theme.colorscheme;
in
lib.mkIf cfg.enable (lib.mkMerge [
  {
    hm.wayland.windowManager.hyprland = {
      config = {
        input = {
          kb_layout = "us";
          follow_mouse = 2;
          float_switch_override_focus = 0;
          numlock_by_default = true;
        };
        
        general = {
          border_size = 1;
          gaps_in = 4;
          gaps_out = 8;
          gaps_workspaces = 50;
          layout = "master";
          resize_on_border = true;
          cursor_inactive_timeout = 10;
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 10;
            passes = 4;
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
          active_shadow_color = "rgba(00000044)";
          inactive_shadow_color = "0x66000000";
        };

        # https://wiki.hyprland.org/Configuring/Dwindle-Layout/#config
        dwindle = {
          no_gaps_when_only = 1;
          pseudotile = true;
          preserve_split = true;
          force_split = 2; # Split right
          special_scale_factor = 0.95;
        };

        # https://wiki.hyprland.org/Configuring/Master-Layout/#config
        master = {
          no_gaps_when_only = 1;
          mfact = 0.5;
          new_is_master = true;
          new_on_top = true;
          orientation = "left";
          inherit_fullscreen = true;
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
      };

      animations.animation = {
        windows = {
          enable = true;
          duration = 200;
          style = "slide";
        };
        windowsOut = {
          enable = true;
          duration = 200;
          style = "slide";
        };
        fade = {
          enable = false;
        };
        workspaces = {
          enable = true;
          duration = 100;
        };
        specialWorkspace = {
          enable = true;
          duration = 100;
          style = "slidevert";
        };
      };
    };
  }
  
  (lib.mkIf (colorscheme != null) {
    hm.wayland.windowManager.hyprland.config = {
      general = {
        active_border_color = "0xff${colorscheme.colors.base0A}";
        inactive_border_color = "0xff${colorscheme.colors.base03}";
      };

      group = {
        active_border_color = "0xff${colorscheme.colors.base0A}";
        inactive_border_color = "0xff${colorscheme.colors.base03}";
        locked_active_border_color = "0xff${colorscheme.colors.base08}";
        locked_inactive_border_color = "0xff${colorscheme.colors.base03}";

        groupbar = {
          active_color = "0xff${colorscheme.colors.base0A}";
          inactive_color = "0xff${colorscheme.colors.base03}";
          locked_active_color = "0xff${colorscheme.colors.base08}";
          locked_inactive_color = "0xff${colorscheme.colors.base03}";
        };
      };
    };
  })
])
