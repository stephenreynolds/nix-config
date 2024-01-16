{ config, lib, inputs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.my.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.my.impermanence = {
    enable = mkEnableOption "Whether to enable opt-in persistence";
    persist = {
      path = mkOption {
        type = types.str;
        default = "/persist";
        description = "The path where files are persisted to";
      };
      directories = mkOption {
        type = with types; listOf (either str attrs);
        default = [ "Downloads" ];
        description = "Directories to persist";
      };
      files = mkOption {
        type = with types; listOf (either str attrs);
        default = [ ];
        description = "Files to persist";
      };
    };
  };

  config = mkIf cfg.enable {
    home.persistence."${cfg.persist.path}${config.home.homeDirectory}" = {
      directories = cfg.persist.directories;
      files = cfg.persist.files;
      allowOther = true;
    };
  };
}
