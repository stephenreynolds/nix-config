{ inputs, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  modules = {
    nix = {
      auto-upgrade.enable = true;
      lowPriority = true;
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
        kaby-lake.enable = true;
      };
      locale = { time.timeZone = "America/Detroit"; };
      networking = {
        networkManager = {
          enable = true;
          randomizeMac = true;
          wireguard-vpn.enable = true;
        };
      };
      nvidia = {
        enable = true;
        open = false;
      };
      pipewire = {
        enable = true;
        lowLatency = true;
      };
      plymouth.enable = true;
      security = {
        mitigations.enable = false;
        secure-boot.enable = true;
        tpm.enable = true;
      };
      ssd.enable = true;
    };
    users = { users.stephen.enable = true; };
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
      tablet = {
        enable = true;
        digimend.enable = true;
      };
      xboxController.enable = true;
      zsa-keyboard.enable = true;
    };
    gaming = {
      enable = true;
      osu-lazer.enable = true;
      yuzu.enable = true;
    };
    services = {
      easyeffects = {
        enable = true;
        preset = {
          enable = true;
          source = ./corsair-virtuoso-wireless-headset/preset.json;
        };
        autoload = {
          enable = true;
          source = ./corsair-virtuoso-wireless-headset/autoload.json;
        };
      };
      geoclue.enable = true;
      gpg.enable = true;
      gvfs.enable = true;
      keyring.enable = true;
      media.enable = true;
      nextdns.enable = true;
      onedrive = {
        enable = true;
        symlinkUserDirs.enable = true;
      };
      openrgb = {
        enable = true;
        profile = ./openrgb-profile.orp;
      };
      openssh.enable = true;
      printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
      };
      protonmail-bridge.enable = true;
      system76-scheduler.enable = true;
    };
    cli = {
      shell = {
        fish.enable = true;
        starship.enable = true;
      };
      bat.enable = true;
      btop.enable = true;
      comma.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git = {
        userName = "Stephen Reynolds";
        userEmail = "mail@stephenreynolds.dev";
        editor = "nvim";
        aliases.enable = true;
      };
      lazygit = { enable = true; };
      lf = {
        enable = true;
        enableIcons = true;
        commands = { swww = true; };
      };
      lsd.enable = true;
      ncmpcpp.enable = true;
      nvim = {
        enable = true;
        defaultEditor = true;
        configSource = inputs.nvim-config;
      };
      tmux.enable = true;
      zoxide.enable = true;
    };
    desktop = {
      enable = true;
      ime.enable = true;
      fonts = {
        profiles = {
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
        extraPackages = with pkgs; [
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          corefonts
          font-awesome
          my.apple-fonts
          my.segoe-fluent-icons
          my.ttf-ms-win11-auto
        ];
      };
      theme = {
        enable = true;
        colorscheme = inputs.nix-colors.colorSchemes.rose-pine;
        gtk = {
          iconTheme = {
            name = "la-capitaine-icon-theme";
            package = pkgs.la-capitaine-icon-theme;
          };
        };
      };
    };
    apps = {
      discord = {
        enable = true;
        discocss.enable = true;
      };
      firefox = {
        enable = true;
        defaultBrowser = true;
        extraProfileConfig.stephen = {
          userChrome = {
            onebar = true;
            hideBloat = true;
          };
          settings = {
            hideBookmarksToolbar = true;
            harden = true;
          };
          search = {
            default = "Brave";
            brave = true;
            phind = true;
            youtube = true;
            github = true;
            sourcegraph = true;
            nix-packages = true;
            nix-options = true;
          };
        };
      };
      thunderbird = {
        enable = true;
        profiles.stephen = { isDefault = true; };
      };
      wine = {
        enable = true;
        winetricks.enable = true;
        bottles.enable = true;
      };
      extraPackages = with pkgs; [
        celluloid
        deluge
        gimp-with-plugins
        krita
        obsidian
        my.allusion
        my.tastytrade
      ];
    };
    dev = { latex.enable = true; };
  };
}
