{ config, lib, pkgs, ... }:
with lib;
let cfg = config.flake.cli.comma;
in {
  options.flake.cli.comma = {
    enable = mkEnableOption "Enable comma";
    nix-index = {
      enable = mkEnableOption "Enable nix-index service";
      timer = {
        enable = mkEnableOption "Enable nix-index timer";
        frequency = mkOption {
          type = types.str;
          default = "daily";
          description = "Frequency of nix-index update";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.comma ];

    hm.programs.nix-index = {
      enable = true;
      enableBashIntegration = config.hm.programs.bash.enable;
      enableFishIntegration = config.hm.programs.fish.enable;
      enableZshIntegration = config.hm.programs.zsh.enable;
    };

    systemd.user.services.nix-update-index = mkIf cfg.nix-index.enable {
      Unit = { Description = "Update nix-index"; };

      Service = {
        Type = "oneshot";
        ExecStart = getExe (pkgs.writeShellApplication {
          name = "nix-index-update";

          runtimeInputs = with pkgs; [ coreutils wget ];

          text = ''
            readonly filename="index-${pkgs.system}"
            readonly release="https://github.com/Mic92/nix-index-database/releases/latest/download/$filename"
            readonly indexDir="${config.xdg.cacheHome}/nix-index"

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

    systemd.user.timers.nix-update-index = mkIf cfg.nix-index.timer.enable {
      Unit = { Description = "Update nix-index"; };

      Timer = {
        OnCalendar = cfg.nix-index.timer.frequency;
        Persistent = true;
      };

      Install.WantedBy = [ "timers.target" ];
    };
  };
}
