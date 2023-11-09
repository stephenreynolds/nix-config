{ config, lib, inputs, pkgs, ... }:
with lib;
let cfg = config.modules.gaming.osu-lazer;
in {
  options.modules.gaming.osu-lazer = {
    enable = mkEnableOption "Whether to install osu!(lazer)";
  };

  config = mkIf cfg.enable {
    hm.home.packages =
      [ inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin ];
  };
}
