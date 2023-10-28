{ config, lib, ... }:
with lib;
let cfg = config.modules.users;
in {
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
    { users.mutableUsers = false; }

    (mkIf cfg.users.stephen.enable {
      users.users.stephen = {
        isNormalUser = true;
        extraGroups = [ "wheel" "input" "audio" "video" "storage" ];
        hashedPasswordFile = config.sops.secrets.stephen-password.path;
      };
    })
  ];
}
