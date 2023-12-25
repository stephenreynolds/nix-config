{ config, lib, ... }:

let cfg = config.my.system.security.tpm;
in {
  options.my.system.security.tpm = {
    enable = lib.mkEnableOption "Whether to enable the TPM";
    tcsd = {
      enable = lib.mkEnableOption ''
        Whether to enable tcsd, a Trusted Computing management service that provides TCG Software Stack (TSS).
      '';
    };
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of users to add to the tss group";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
        tctiEnvironment.enable = true;
      };

      users.groups.tss.members = cfg.users;
    }

    (lib.mkIf cfg.tcsd.enable {
      services.tcsd.enable = true;
    })
  ]);
}
