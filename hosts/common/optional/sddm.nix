{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "chili";
        autoNumlock = true;
        settings = {
          Theme = {
            CursorTheme = "macOS-BigSur-White";
            CursorSize = 24;
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sddm-chili-theme
    apple-cursor
  ];
}
