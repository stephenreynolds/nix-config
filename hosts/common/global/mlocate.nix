{ pkgs, ... }:
{
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
  };
}
