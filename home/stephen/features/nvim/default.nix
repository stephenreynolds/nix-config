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
      php
      luarocks
      jdk17
      python3
      python311Packages.pip
      julia
      ruby
      tree-sitter
      nil
    ];
  };
}
