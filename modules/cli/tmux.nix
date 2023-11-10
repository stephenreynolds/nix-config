{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.cli.tmux;
in {
  options.modules.cli.tmux = { enable = mkEnableOption "Enable tmux"; };

  config = mkIf cfg.enable {
    hm.programs.tmux =
      let
        tmux-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "tmux-window-name";
          version = "unstable-2023-10-19";
          src = pkgs.fetchFromGitHub {
            owner = "ofirgall";
            repo = "tmux-window-name";
            rev = "bc6c5cfb6fd2d37f87515d4aa1977822e4fda2cc";
            sha256 = "NZR/jMd75wOsAgzqDW36fsmffbR7CCr0wMk59xbcS+o=";
          };
        };
      in
      {
        enable = true;
        baseIndex = 1;
        disableConfirmationPrompt = true;
        escapeTime = 1;
        keyMode = "vi";
        mouse = true;
        newSession = true;
        prefix = "C-Space";
        terminal = "screen-256color";
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-vim "session"
              set -g @resurrect-strategy-nvim "session"
              set -g @resurrect-capture-pane-contents "on"
            '';
          }
          {
            plugin = tmuxPlugins.catppuccin;
            extraConfig = "set -g @catppuccin_flavour 'mocha'";
          }
          tmuxPlugins.vim-tmux-navigator
          tmuxPlugins.sensible
          tmuxPlugins.tmux-fzf
          tmux-window-name
        ];
        extraConfig = ''
          set -ga terminal-overrides ",*256col*:Tc"

          bind r source-file ~/.config/tmux/tmux.conf

          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

          # Select pane
          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R

          # Split window
          bind | split-window -h
          bind - split-window -v
          unbind '"'
          unbind %

          # Toggle between current and previous window
          set -g renumber-windows on
          bind c new-window -c "#{pane_current_path}"
          bind Space last-window

          bind T display-popup -E "tt"
          set-option -g detach-on-destroy off

          # Disable status bar
          set -g status off
        '';
      };
  };
}
