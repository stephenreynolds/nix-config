{ config, lib, pkgs, ... }:

let
  cfg = config.modules.cli.fzf;
  colorscheme = config.modules.desktop.theme.colorscheme;
in {
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
      hm.programs.fzf = let ag = "${pkgs.silver-searcher}/bin/ag";
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
      hm.programs.fzf.colors = let inherit (colorscheme) palette;
      in {
        "bg+" = "#${palette.base02}";
        bg = "#${palette.base00}";
        spinner = "#${palette.base06}";
        hl = "#${palette.base08}";
        fg = "#${palette.base05}";
        header = "#${palette.base08}";
        info = "#${palette.base0E}";
        pointer = "#${palette.base06}";
        marker = "#${palette.base06}";
        "fg+" = "#${palette.base05}";
        prompt = "#${palette.base0E}";
        "hl+" = "#${palette.base08}";
      };
    })
  ]);
}
