{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.nextcloud-client
  ];

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
