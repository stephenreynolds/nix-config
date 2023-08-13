{ pkgs, ... }:
{
  fontProfiles = {
    enable = true;
    monospace = {
      family = "CaskaydiaCove Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
    };
    regular = {
      family = "Inter";
      package = pkgs.inter;
    };
  };
}
