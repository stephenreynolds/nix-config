{ config, lib, ... }:
with lib;
let cfg = config.modules.users;
in {
  options.user = mkOption {
    type = types.attrs;
    default = { };
  };

  options.modules.users = {
    users = {
      stephen = { enable = mkEnableOption "Enable Stephen's user account"; };
    };

    mutableUsers = mkEnableOption ''
      Allow adding new users and groups using `useradd` and `groupadd` commands.
      If set to false, users and groups will be replaced on system activation.
    '';
  };

  config = mkMerge [
    { users.mutableUsers = cfg.mutableUsers; }

    (mkIf cfg.users.stephen.enable {
      user = let
        user = builtins.getEnv "USER";
        name = if elem user [ "" "root" ] then "stephen" else user;
      in { inherit name; };

      users.users.stephen = {
        isNormalUser = true;
        extraGroups = [ "wheel" "input" "audio" "video" "storage" ];
        initialPassword = "test";
      };
    })
  ];
}
