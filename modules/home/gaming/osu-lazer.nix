{ config, lib, inputs, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.gaming.osu-lazer;
in
{
  options.my.gaming.osu-lazer = {
    enable = mkEnableOption "Whether to install osu!(lazer)";
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin ];
  };
}
