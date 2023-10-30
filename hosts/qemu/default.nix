{ inputs, ... }: {
  imports = [ ./hardware.nix ];

  modules = {
    system = {
      boot = {
        bootloader = "systemd-boot";
        initrd.systemd.enable = true;
      };
      networking = { networkManager.enable = true; };
      locale = { time.timeZone = "America/Detroit"; };
    };
    users = { users.stephen.enable = true; };
    services = {
      gpg.enable = true;
      keyring.enable = true;
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
