{ config, inputs, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  modules = {
    nix = { auto-upgrade.enable = true; };
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
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
      pipewire.enable = true;
      plymouth.enable = true;
      security = {
        mitigations.enable = false;
        secure-boot.enable = true;
        tpm.enable = true;
      };
      ssd.enable = true;
      virtualisation.host.enable = true;
    };
    users = { users.stephen.enable = true; };
    devices = {
      monitors = [
        {
          name = "DP-1";
          primary = true;
          width = 3840;
          height = 2160;
          scaling = 1.5;
          bitdepth = 10;
          vrr = 1;
        }
      ];
      xboxController.enable = true;
      zsa-keyboard.enable = true;
    };
    gaming = {
      enable = true;
      lutris.enable = true;
      melonDS.enable = true;
      osu-lazer.enable = true;
      proton.protontricks.enable = true;
    };
    services = {
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
      openssh = {
        enable = false;
        hostKey.enable = true;
      };
      printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
      };
      system76-scheduler.enable = true;
    };
    cli = {
      shell = {
        fish.enable = true;
        starship.enable = true;
      };
      bat.enable = true;
      btop.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git = {
        userName = "Stephen Reynolds";
        userEmail = "mail@stephenreynolds.dev";
        editor = "nvim";
        aliases.enable = true;
        signing = {
          key = "${config.hm.home.homeDirectory}/.ssh/id_ed25519";
          gpg.format = "ssh";
          signByDefault = true;
        };
      };
      lazygit = { enable = true; };
      lf = {
        enable = true;
        enableIcons = true;
        commands = { swww = true; };
      };
      lsd.enable = true;
      ncmpcpp.enable = true;
      nix-index = {
        enable = true;
        comma.enable = true;
      };
      nvim = {
        enable = true;
        defaultEditor = true;
      };
      tmux.enable = true;
      zoxide.enable = true;
    };
    desktop = {
      enable = true;
      fonts = {
        profiles = {
          enable = true;
          monospace = {
            family = "CaskaydiaCove Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
          };
          regular = {
            family = "Ubuntu Regular";
            package = pkgs.ubuntu_font_family;
          };
        };
        extraPackages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-emoji
          corefonts
          font-awesome
          inter
          material-symbols
          my.ttf-ms-win11-auto
        ];
      };
      theme = {
        enable = true;
        colorscheme = inputs.nix-colors.colorSchemes.rose-pine;
        gtk = {
          iconTheme = {
            name = "Yaru-blue";
            package = pkgs.yaru-theme;
          };
          soundTheme = {
            name = "Yaru";
            package = pkgs.yaru-theme;
          };
        };
      };
    };
    apps = {
      allusion.enable = true;
      electron-mail.enable = true;
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
            devtools.keybindings = "vim";
          };
          search = {
            default = "Brave";
            brave = true;
            youtube = true;
            github = true;
            sourcegraph = true;
            nix-packages = true;
            nix-options = true;
          };
        };
      };
      nautilus.bookmarks = ''
        file:///home/stephen/src Source
      '';
      obsidian.enable = true;
      vesktop.enable = true;
      wine = {
        enable = true;
        winetricks.enable = true;
        bottles.enable = true;
      };
      zathura.enable = true;
      extraPackages = with pkgs; [
        celluloid
        deluge-gtk
        galaxy-buds-client
        gimp
        just
        krita
      ];
    };
    dev = {
      docker.enable = true;
      podman = {
        enable = true;
        docker-compose.enable = true;
      };
      distrobox.enable = true;
    };
  };
}
