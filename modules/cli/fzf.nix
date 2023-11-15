{ config, lib, pkgs, ... }:

let
  cfg = config.modules.cli.fzf;
  colorscheme = config.modules.desktop.theme.colorscheme;
in
{
  options.modules.cli.fzf = {
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
      hm.programs.fzf = {
        enable = true;
        colors = cfg.colors;
      };
    }

    (lib.mkIf cfg.silver-searcher {
      hm.programs.fzf =
        let ag = "${pkgs.silver-searcher}/bin/ag";
        in {
          defaultCommand = "${ag} -g ''";
          fileWidgetCommand = "${ag} --hidden";
        };
    })

    (lib.mkIf cfg.shellIntegrations {
      hm.programs.fzf = {
        enableBashIntegration = true;
        enableFishIntegration = config.modules.cli.shell.fish.enable;
        # TODO: use flake config for tmux
        tmux.enableShellIntegration = config.programs.tmux.enable;
      };
    })

    (lib.mkIf (colorscheme != null) {
      hm.programs.fzf.colors =
        let inherit (colorscheme) colors;
        in {
          "bg+" = "#${colors.base02}";
          bg = "#${colors.base00}";
          spinner = "#${colors.base06}";
          hl = "#${colors.base08}";
          fg = "#${colors.base05}";
          header = "#${colors.base08}";
          info = "#${colors.base0E}";
          pointer = "#${colors.base06}";
          marker = "#${colors.base06}";
          "fg+" = "#${colors.base05}";
          prompt = "#${colors.base0E}";
          "hl+" = "#${colors.base08}";
        };
    })
  ]);
}
