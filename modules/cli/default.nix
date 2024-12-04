{ config, lib, pkgs, ... }:

let cfg = config.modules.cli;
in {
  options.modules.cli = {
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        ripgrep
        sad
        fd
        jq
        wget
        tree
        unzip
        trash-cli
        mtr
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
