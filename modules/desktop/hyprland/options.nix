{ config, lib, ... }:

let
  cfg = config.modules.desktop.hyprland;
  configPath = "${cfg.configPath}/20-options.conf";
  colorscheme = config.modules.desktop.theme.colorscheme;
in
lib.mkIf cfg.enable {
  hm.home.file."${configPath}".text = ''
    input {
      kb_layout = us

      follow_mouse = 2
      float_switch_override_focus = 0

      numlock_by_default = true
    }

    general {
      gaps_in = 0
      gaps_out = 0

      border_size = 1

      layout = master

      resize_on_border = true

      cursor_inactive_timeout = 10
    }

    decoration {
      rounding = 0

      blur {
        enabled = true
        size = 10
        passes = 4
        new_optimizations = true
        xray = true
        noise = 0.0117
        contrast = 1
        special = false
      }

      drop_shadow = true
      shadow_range = 15
      shadow_render_power = 6
      shadow_offset = 0 2
      col.shadow = rgba(00000044)
      col.shadow_inactive = 0x66000000
    }

    animations {
      enabled = true

      animation = windows, 1, 2, default, slide
      animation = windowsOut, 1, 2, default, slide
      animation = fade, 0, 1, default
      animation = workspaces, 1, 1, default
      animation = specialWorkspace, 1, 1, default, slidevert
    }

    # https://wiki.hyprland.org/Configuring/Dwindle-Layout/#config
    dwindle {
      no_gaps_when_only = 1
      pseudotile = true
      preserve_split = true
      force_split = 2 # Split right
      special_scale_factor = 0.95
    }

    # https://wiki.hyprland.org/Configuring/Master-Layout/#config
    master {
      no_gaps_when_only = 1
      mfact = 0.5
      new_is_master = true
      new_on_top = true
      orientation = left
      inherit_fullscreen = true
      special_scale_factor = 0.95
    }

    binds {
      workspace_back_and_forth = true
      allow_workspace_cycles = true
    }

    group {
      groupbar {
        render_titles = false
      }
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      focus_on_activate = true
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
      allow_session_lock_restore = true
      enable_swallow = false
      swallow_regex = ^(kitty)$
      new_window_takes_over_fullscreen = 1
    }
  '' + lib.optionalString (colorscheme != null) ''
    general {
      col.active_border = 0xff${colorscheme.colors.base0A}
      col.inactive_border = 0xff${colorscheme.colors.base03}
    }

    group {
      col.border_active = 0xff${colorscheme.colors.base0A}
      col.border_inactive = 0xff${colorscheme.colors.base03}
      col.border_locked_active = 0xff${colorscheme.colors.base08}
      col.border_locked_inactive = 0xff${colorscheme.colors.base03}

      groupbar {
        col.active = 0xff${colorscheme.colors.base0A}
        col.inactive = 0xff${colorscheme.colors.base03}
        col.locked_active = 0xff${colorscheme.colors.base08}
        col.locked_inactive = 0xff${colorscheme.colors.base03}
      }
    }

    debug {
      disable_logs = false
    }
  '';
}
