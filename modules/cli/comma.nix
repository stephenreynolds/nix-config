{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.cli.comma;
in {
  options.modules.cli.comma = {
    enable = mkEnableOption "Enable comma";
    nix-index = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable nix-index service";
      };
      frequency = mkOption {
        type = types.str;
        default = "daily";
        description = "Frequency of nix-index update";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.home.packages = [ pkgs.comma ];

      hm.programs.nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = config.hm.programs.fish.enable;
        enableZshIntegration = config.hm.programs.zsh.enable;
      };
    }

    (mkIf cfg.nix-index.enable {
      hm.systemd.user.services.nix-update-index = {
        Unit = { Description = "Update nix-index"; };

        Service = {
          Type = "oneshot";
          ExecStart = getExe (pkgs.writeShellApplication {
            name = "nix-index-update";

            runtimeInputs = with pkgs; [ coreutils wget ];

            text = ''
              readonly filename="index-${pkgs.system}"
              readonly release="https://github.com/Mic92/nix-index-database/releases/latest/download/$filename"
              readonly indexDir="${config.hm.xdg.cacheHome}/nix-index"

              mkdir -p "$indexDir"

              pushd "$indexDir" > /dev/null

              trap "popd > /dev/null" EXIT

              wget -q -N "$release"

              ln -f "$filename" files

              echo "Finished updating nix-index"
            '';
          });
        };
      };

      hm.systemd.user.timers.nix-update-index = {
        Unit = { Description = "Update nix-index"; };

        Timer = {
          OnCalendar = cfg.nix-index.frequency;
          Persistent = true;
        };

        Install.WantedBy = [ "timers.target" ];
      };
    })
  ]);
}
