{ pkgs, ... }:
{
  # TODO: Declaratively configure nvim config
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      gcc
      gnumake
      nodejs
      fzf
      unzip
      sqlite
      luajitPackages.sqlite
      wget
      go
      cargo
      luarocks
      tree-sitter
      nil
    ];
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".config/nvim"
      ".local/share/nvim"
    ];
  };
}
