{ config, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      font = "${config.fontProfiles.regular.family} 12";
      recolor = true;
    };
  };
}
