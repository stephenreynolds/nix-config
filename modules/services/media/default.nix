{ config, lib, ... }:
with lib; {
  options.modules.services.media = {
    enable = mkEnableOption "Whether to enable media services";
  };
}
