{ config, lib, pkgs, ... }:

let
  inherit (lib) types mkOption;
  cfg = config.my.cli;
in
{
  options.my.cli = {
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        ripgrep
        sad
        fd
        jq
        wget
        tree
        unzip
        trash-cli
      ];
      description = "Packages to install in the CLI environment";
    };
  };

  config = {
    home.packages = cfg.extraPackages;
  };
}
