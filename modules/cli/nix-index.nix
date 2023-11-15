{ config, lib, inputs, ... }:

let cfg = config.modules.cli.nix-index;
in {
  options.modules.cli.nix-index = {
    enable = lib.mkEnableOption "Enable nix-index";
    comma = {
      enable = lib.mkEnableOption "Install comma";
    };
  };

  config = lib.mkIf cfg.enable {
    hm.imports = [ inputs.nix-index-database.hmModules.nix-index ];

    hm.programs = {
      nix-index.enable = true;
      nix-index-database.comma.enable = cfg.comma.enable;
    };
  };
}
