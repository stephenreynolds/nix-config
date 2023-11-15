{ config, lib, ... }:

let cfg = config.modules.system.security.tpm;
in {
  options.modules.system.security.tpm = {
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
