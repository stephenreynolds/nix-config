{ lib, ... }:

{
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "stephen";
      description = "The username";
    };
  };
}
