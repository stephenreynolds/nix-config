{ inputs, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  my = {
    desktop = {
      enable = true;
      hyprland.enable = true;
      displayManager.regreet.enable = true;
      pam.swaylock = true;
      ime.enable = true;
      fonts.profiles = {
        enable = true;
        monospace = {
          family = "CaskaydiaCove Nerd Font";
          package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
        };
        regular = {
          family = "SF Pro Display";
          package = pkgs.my.apple-fonts;
        };
      };
      theme = {
        colorscheme = inputs.nix-colors.colorSchemes.rose-pine;
        cursor.enable = true;
        gtk.iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
      };
    };
    devices = {
      monitors = [
        {
          name = "DP-1";
          x = 0;
        }
        {
          name = "DP-2";
          x = 1920;
          primary = true;
        }
        {
          name = "HDMI-A-1";
          x = 3840;
        }
      ];
      xboxController.enable = true;
      zsa-keyboard = {
        enable = true;
        keymapp.enable = true;
      };
    };
    gaming = {
      enable = true;
    };
    services = {
      geoclue.enable = true;
      keyring.enable = true;
      onedrive.enable = true;
      openrgb = {
        enable = true;
        profile = ./openrgb-profile.orp;
      };
      system76-scheduler.enable = true;
    };
    system = {
      bluetooth = {
        enable = true;
        blueman.enable = true;
      };
      boot = {
        initrd.systemd.enable = true;
        iommu.enable = true;
      };
      cpu.intel = {
        enable = true;
        gpu.blacklist = true;
      };
      locale.time.timeZone = "America/Detroit";
      networking = {
        networkManager = {
          enable = true;
          wireguard-vpn.enable = true;
        };
      };
      nvidia.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;
      security = {
        mitigations.disable = true;
        secure-boot.enable = true;
        tpm.enable = true;
      };
      ssd.enable = true;
    };
    users = {
      users.stephen = {
        shell = pkgs.fish;
        extraGroups = [ "wheel" "input" "audio" "video" "storage" ];
        optionalGroups = [
          "i2c"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "mlocate"
          "flatpak"
          "tss"
          "libvirtd"
          "gamemode"
          "nix-access-tokens"
          "openai-api-key"
        ];
      };
    };
    virtualisation = {
      host.enable = true;
      podman.enable = true;
    };
  };
}
