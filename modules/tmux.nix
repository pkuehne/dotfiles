{ pkgs, ... }:
let
  # Not in nixpkgs: MunifTanjim/tmux-suspend
  tmuxSuspend = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-suspend";
    version = "unstable-2025-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "tmux-suspend";
      rev = "1a2f806666e0bfed37535372279fa00d27d50d14";
      hash = "sha256-+1fKkwDmr5iqro0XeL8gkjOGGB/YHBD25NG+w3iW+0g=";
    };
  };
in {
  programs.tmux = {
    enable = true;

    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      sessionist
      tmuxSuspend
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @resurrect-dir "$HOME/.local/share/tmux/resurrect"
          set -g @resurrect-capture-pane-contents "on"
          # If you use continuum's countdown mode via Dracula:
          set -g @dracula-continuum-mode countdown
        '';
      }
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-left-icon-padding 0
          set -g @dracula-plugins "continuum battery cpu-usage time weather"
          set -g @dracula-battery-label ""
          set -g @dracula-cpu-usage-label ""
          set -g @dracula-time-format "%F %R"
          set -g @dracula-show-fahrenheit false
          set -g @dracula-fixed-location "Redhill"
          set -g @dracula-theme 'dark'
          # Matches your suspended-state status tweak
          set -g @suspend_suspended_options " \
            status-left::"'#[bg=colour1]  #[bg=colour239]#[fg=colour1]'", \
          "
        '';
      }
    ];

    extraConfig = ''
      # Make function keys behave
      setw -g xterm-keys on

      # Automatically renumber tmux windows
      set -g renumber-windows on

      # Allow me to set the name
      set -g allow-rename off

      # Number panes from 1 as well
      setw -g pane-base-index 1

      # New window on N
      bind N new-window

      # Saner splits (preserve cwd)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Fast ESC handled above via escapeTime, but for completeness:
      set-option -g escape-time 0

      # Pane switching (Alt + arrows / hjkl)
      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D
      bind -n M-h     select-pane -L
      bind -n M-l     select-pane -R
      bind -n M-k     select-pane -U
      bind -n M-j     select-pane -D
    '';
  };
}

