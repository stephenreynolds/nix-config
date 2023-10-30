{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.cli.fzf;
in {
  options.modules.cli.fzf = {
    enable = mkEnableOption "Enable fzf";
    colors = mkOption {
      type = types.nullOr types.attrs;
      default = { };
      description = "Color scheme to use";
    };
    silver-searcher = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use silver-searcher.";
    };
    shellIntegrations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shell integrations";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hm.programs.fzf = {
        enable = true;
        colors = cfg.colors;
      };
    }

    (mkIf cfg.silver-searcher {
      hm.programs.fzf = let ag = "${pkgs.silver-searcher}/bin/ag";
      in {
        defaultCommand = "${ag} -g ''";
        fileWidgetCommand = "${ag} --hidden";
      };
    })

    (mkIf cfg.shellIntegrations {
      hm.programs.fzf = {
        enableBashIntegration = true;
        enableFishIntegration = config.modules.cli.shell.fish.enable;
        # TODO: use flake config for tmux
        tmux.enableShellIntegration = config.programs.tmux.enable;
      };
    })
  ]);
}
