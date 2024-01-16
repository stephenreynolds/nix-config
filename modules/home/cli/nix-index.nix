{ config, lib, inputs, ... }:

let cfg = config.my.cli.nix-index;
in {
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.my.cli.nix-index = {
    enable = lib.mkEnableOption "Enable nix-index";
    comma = {
      enable = lib.mkEnableOption "Install comma";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = cfg.comma.enable;
    };
  };
}
