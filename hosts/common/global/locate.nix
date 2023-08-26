{ pkgs, ... }:
{
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";

    # Suppress "mlocate does not support localuser" warning
    localuser = null;
  };
}
