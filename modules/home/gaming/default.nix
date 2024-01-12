{ config, lib, ... }:

let
  inherit (lib) mkEnableOption;
  cfg = config.my.gaming;
in
{
  options.my.gaming = {
    enable = mkEnableOption "Whether to enable gaming-related features";
  };
}
