{ inputs, pkgs, ... }: {
  imports = [ ./hardware.nix ];

  modules = {
    nix = {
      auto-upgrade.enable = true;
      lowPriority = true;
    };
    system = {
      boot = {
        bootloader = "systemd-boot";
        initrd.systemd.enable = true;
      };
      networking = {
        networkManager = {
          enable = true;
          backend = "iwd";
          randomizeMac = true;
        };
      };
      locale = { time.timeZone = "America/Detroit"; };
      virtualisation = {
        guest = {
          spice = true;
          qemu = true;
          qxl = true;
        };
      };
    };
    users = { users.stephen.enable = true; };
    services = {
      gpg.enable = true;
      keyring.enable = true;
      nextdns.enable = true;
      openssh.enable = true;
      printing = {
        enable = true;
        drivers = [ pkgs.hplip ];
      };
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
  };
}
