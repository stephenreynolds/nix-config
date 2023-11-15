{ lib, ... }:

{
  options.modules.services.media = {
    enable = lib.mkEnableOption "Whether to enable media services";
  };
}
