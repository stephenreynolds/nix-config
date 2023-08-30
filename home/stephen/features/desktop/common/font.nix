{ pkgs, ... }:
{
  fontProfiles = {
    enable = true;
    monospace = {
      family = "CaskaydiaCove Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
    };
    regular = {
      family = "SF Pro Display";
      package = pkgs.apple-fonts;
    };
  };

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    corefonts
    font-awesome
    apple-fonts
    segoe-fluent-icons
  ];
}
