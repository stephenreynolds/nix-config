{ config, lib, inputs, pkgs, ... }:

let cfg = config.modules.gaming.osu-lazer;
in {
  options.modules.gaming.osu-lazer = {
    enable = lib.mkEnableOption "Whether to install osu!(lazer)";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages =
      [ inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin ];
  };
}
