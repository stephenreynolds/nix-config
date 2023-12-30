{ config, pkgs, ... }:

{
  my = {
    apps = {
      firefox = {
        enable = true;
        defaultBrowser = true;
        vaapi.enable = true;
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
    };
    cli = {
      btop.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git = {
        userName = "Stephen Reynolds";
        userEmail = "mail@stephenreynolds.dev";
        editor = "nvim";
        aliases.enable = true;
        signing = {
          key = "${config.home.homeDirectory}/.ssh/id_ed25519";
          gpg.format = "ssh";
          signByDefault = true;
        };
      };
      lazygit.enable = true;
      lf.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
      shell = {
        fish.enable = true;
        starship.enable = true;
      };
      zoxide.enable = true;
    };
    services = {
      onedrive = {
        enable = true;
        symlinkUserDirs.enable = false;
      };
    };
  };

  home.packages = with pkgs; [
    blackbox-terminal
  ];
}
