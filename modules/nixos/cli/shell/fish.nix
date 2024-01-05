{ config, lib, pkgs, ... }:

let
  cfg = config.my.cli.shell.fish;

  userWantsFish = builtins.any
    (user: user.shell == pkgs.fish)
    (lib.attrsets.attrValues config.users.users);
in
{
  options.my.cli.shell.fish = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = userWantsFish;
      description = "Whether to enable the Fish shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };
}
