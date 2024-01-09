# WSL (Windows Subsystem for Linux)
{ config, ... }:

{
  my = {
    cli = {
      bat.enable = true;
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
      lsd.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
      shell = {
        fish.enable = true;
        starship.enable = true;
      };
      wsl.enable = true;
      zoxide.enable = true;
    };
    user = {
      name = "stephen";
    };
  };
}
