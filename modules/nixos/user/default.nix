{ config, lib, ... }:

let
  cfg = config.my.user;
in
{
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "stephen";
      description = "The name to use for the user account.";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Stephen Reynolds";
      description = "The full name of the user.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "mail@stephenreynolds.dev";
      description = "The email address of the user.";
    };
    initialPassword = lib.mkOption {
      type = lib.types.str;
      default = "password";
      description = "The initial password to use when the user is first created.";
    };
  };

  config = {
    users.users.${cfg.name} = {
      inherit (cfg) name initialPassword;
      isNormalUser = true;
    };
  };
}
