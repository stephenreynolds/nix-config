{ lib, ... }:

let inherit (lib) mkOption types;
in {
  options.my.desktop.theme = {
    colorscheme = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = "The colorscheme to use";
    };
  };
}
