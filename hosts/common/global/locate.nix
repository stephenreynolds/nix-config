{ pkgs, ... }:
{
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";

    # Suppress "mlocate and plocate do not support localuser" warning
    localuser = null;
  };
}
