{ pkgs, ... }:
{
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
}
