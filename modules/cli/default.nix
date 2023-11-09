{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.cli;
in {
  options.modules.cli = {
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        distrobox
        ripgrep
        sad
        fd
        jq
        wget
        tree
        unzip
        trash-cli
        my.t
        my.tt
      ];
      description = "Packages to install in the CLI environment";
    };
  };

  config = {
    environment.enableAllTerminfo = true;

    hm.home.packages = cfg.extraPackages;
  };
}
