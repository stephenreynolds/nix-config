{ config, lib, ... }:
with lib;
let cfg = config.modules.system.security.tpm;
in {
  options.modules.system.security.tpm = {
    enable = mkEnableOption "Whether to enable the TPM";
  };

  config = mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
