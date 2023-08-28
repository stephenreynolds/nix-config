{ pkgs, ... }:
{
  imports = [
    ./swww.nix
    ./waybar.nix
    ./kitty.nix
    ./mako.nix
    ./swayidle.nix
    ./swaylock.nix
    ./sway-audio-idle-inhibit.nix
    ./wofi.nix
    ./zathura.nix
  ];

  xdg = {
    enable = true;
    mimeApps.enable = true;
    userDirs.enable = true;
    configFile."mimeapps.list".force = true;
  };

  home.packages = with pkgs; [
    gtk3
    qt6.qtwayland
    qt5.qtwayland
    imv
    primary-xwayland
    pulseaudio
    wl-clipboard
    xdg-utils
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    #SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  services.gnome-policykit-agent.enable = true;
}
