{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-markdown-preview
    ];
  };

  home.persistence = {
    "/nix/persist/home/stephen".directories = [ ".config/gh" ];
  };
}
