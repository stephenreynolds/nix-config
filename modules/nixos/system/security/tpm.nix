{ config, lib, ... }:

let cfg = config.my.system.security.tpm;
in {
  options.my.system.security.tpm = {
    enable = lib.mkEnableOption "Whether to enable the TPM";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of users to add to the tss group";
    };
  };

  config = lib.mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    users.groups.tss.members = cfg.users;
  };
}
