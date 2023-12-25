{ config, lib, ... }:

let cfg = config.my.system.security.tpm;
in {
  options.my.system.security.tpm = {
    enable = lib.mkEnableOption "Whether to enable the TPM";
  };

  config = lib.mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
