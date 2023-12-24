{ lib, config, ... }:

let
  cfg = config.my.user;

  home-directory = "/home/${cfg.name}";
in
{
  options.my.user = {
    enable = lib.mkEnableOption "Whether to configure the user account.";
    name = lib.mkOption {
      type = lib.types.str;
      default = "stephen";
      description = "The username.";
    };
    home = lib.mkOption {
      type = lib.types.str;
      default = home-directory;
      description = "The path to the user's home directory.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home = {
        username = lib.mkDefault cfg.name;
        homeDirectory = lib.mkDefault cfg.home;
      };
    }
  ]);
}
