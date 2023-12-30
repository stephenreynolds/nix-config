{ config, lib, pkgs, ... }:

let
  cfg = config.my.cli.fzf;
in
{
  options.my.cli.fzf = {
    enable = lib.mkEnableOption "Enable fzf";
    colors = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = { };
      description = "Color scheme to use";
    };
    silver-searcher = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use silver-searcher.";
    };
    shellIntegrations = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable shell integrations";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.fzf = {
        enable = true;
        colors = cfg.colors;
      };
    }

    (lib.mkIf cfg.silver-searcher {
      programs.fzf =
        let ag = "${pkgs.silver-searcher}/bin/ag";
        in {
          defaultCommand = "${ag} -g ''";
          fileWidgetCommand = "${ag} --hidden";
        };
    })

    (lib.mkIf cfg.shellIntegrations {
      programs.fzf = {
        enableBashIntegration = true;
        enableFishIntegration = config.programs.fish.enable;
        tmux.enableShellIntegration = config.programs.tmux.enable;
      };
    })
  ]);
}
