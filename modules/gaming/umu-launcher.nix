{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.modules.gaming.umu-launcher;
in
{
  options.modules.gaming.umu-launcher = {
    enable = mkEnableOption {
      type = types.bool;
      default = config.modules.gaming.enable;
      description = "Whether to install umu launcher";
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [
      inputs.nix-gaming.packages.${pkgs.system}.umu-launcher
    ];

    modules.system.persist.state.home.directories = [
      ".local/share/umu"
    ];
  };
}
