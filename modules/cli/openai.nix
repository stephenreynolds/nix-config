{ config, lib, ... }:
with lib;
let cfg = config.modules.cli.openai;
in {
  options.modules.cli.openai = {
    api-key = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install the OpenAI API key";
      };
    };
  };

  config = mkIf cfg.api-key.enable {
    sops.secrets.openai-api-key = {
      sopsFile = ../sops/secrets.yaml;
      group = config.users.groups.openai-api-key.name;
      mode = "0440";
    };

    users.groups.openai-api-key = { };
  };
}
