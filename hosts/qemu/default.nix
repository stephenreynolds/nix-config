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
        bootloader = "systemd-boot";
        initrd.systemd.enable = true;
      };
      locale = { time.timeZone = "America/Detroit"; };
      networking = {
        networkManager = {
          enable = true;
          backend = "iwd";
          randomizeMac = true;
          wireguard-vpn.enable = true;
        };
      };
      pipewire = {
        enable = true;
        lowLatency = true;
      };
      plymouth.enable = true;
      security = {
        mitigations.enable = false;
        secure-boot.enable = true;
      };
      virtualisation = {
        guest = {
          spice = true;
          qemu = true;
          qxl = true;
        };
      };
    };
    users = { users.stephen.enable = true; };
    devices = {
      tablet = {
        enable = true;
        digimend.enable = true;
      };
      xboxController.enable = true;
    };
    gaming.enable = true;
    services = {
      gpg.enable = true;
      keyring.enable = true;
      nextdns.enable = true;
      onedrive = {
        enable = true;
        symlinkUserDirs.enable = true;
      };
      openssh.enable = true;
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
      nvim = {
        enable = true;
        defaultEditor = true;
        configSource = inputs.nvim-config;
      };
      tmux.enable = true;
      zoxide.enable = true;
    };
    desktop = { ime.enable = true; };
  };
}
