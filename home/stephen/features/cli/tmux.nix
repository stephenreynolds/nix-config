{ pkgs, ...}:
let
  tmux-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-window-name";
    version = "unstable-2023-05-26";
    src = pkgs.fetchFromGitHub {
      owner = "ofirgall";
      repo = "tmux-window-name";
      rev = "19b65efa8c37501799789194be2a99293e67c632";
      sha256 = "sha256-VHtnN9XyEv8Gbwq5bJuq8QS04opwDOTGzEcLREy6kBA=";
    };
  };
in
{ 
  programs.tmux = {
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
}
