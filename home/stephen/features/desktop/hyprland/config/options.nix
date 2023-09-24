{ config, ... }:
{
  wayland.windowManager.hyprland.extraConfig = ''
    input {
      kb_layout = us

      follow_mouse = 2
      float_switch_override_focus = 2

      numlock_by_default = true
    }

    general {
      gaps_in = 5
      gaps_out = 10

      border_size = 1
      col.active_border = 0xff${config.colorscheme.colors.base0C}
      col.inactive_border = 0xff${config.colorscheme.colors.base02}
      col.group_border = 0xff${config.colorscheme.colors.base04}
      col.group_border_active = 0xff${config.colorscheme.colors.base0B}

      layout = master

      resize_on_border = true
    }

    decoration {
      rounding = 0

      blur {
        enabled = true
        size = 5
        passes = 4
        new_optimizations = true
        xray = false
        noise = 0.0117
        special = false
      }

      drop_shadow = true
      shadow_range = 30
      col.shadow = 0x44000000
      col.shadow_inactive = 0x66000000
    }

    animations {
      enabled = true

      bezier = overshot, 0.05, 0.9, 0.1, 1.1

      animation = windows, 1, 2, overshot
      animation = windowsOut, 1, 2, default, popin 80%
      animation = border, 1, 10, default
      animation = borderangle, 1, 8, default
      animation = fade, 1, 2, default
      animation = workspaces, 1, 2, default
      animation = specialWorkspace, 1, 2, default, slidevert
    }

    dwindle {
      no_gaps_when_only = 1
      pseudotile = true
      preserve_split = true
      force_split = 2 # Split right
    }

    master {
      no_gaps_when_only = 1
      mfact = 0.55
      new_is_master = true
      new_on_top = true
      orientation = center
      inherit_fullscreen = true
    }

    binds {
      workspace_back_and_forth = true
      allow_workspace_cycles = true
      ignore_group_lock = true
    }

    misc {
      focus_on_activate = true
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
      allow_session_lock_restore = true
      render_titles_in_groupbar = false
      enable_swallow = true
      swallow_regex = ^(kitty)$
    }

    xwayland {
      force_zero_scaling = true
    }
  '';
}
