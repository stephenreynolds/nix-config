{ config, lib, ... }:

let cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = lib.mkEnableOption "Enable a desktop environment";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      security.polkit.enable = true;
    }
  ]);
}
