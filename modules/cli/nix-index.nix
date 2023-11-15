{ config, lib, inputs, ... }:
with lib;
let cfg = config.modules.cli.nix-index;
in {
  options.modules.cli.nix-index = {
    enable = mkEnableOption "Enable nix-index";
    comma = {
      enable = mkEnableOption "Install comma";
    };
  };

  config = mkIf cfg.enable {
    hm.imports = [ inputs.nix-index-database.hmModules.nix-index ];

    hm.programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = cfg.comma.enable;
    };
  };
}
