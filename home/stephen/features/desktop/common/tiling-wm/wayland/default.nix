{ pkgs, ... }:
{
  imports = [
    ../default.nix
    ./ags.nix
    ./gtklock.nix
    ./swww.nix
    ./swayidle.nix
    ./sway-audio-idle-inhibit.nix
  ];

  home.packages = with pkgs; [
    qt6.qtwayland
    qt5.qtwayland
    primary-xwayland
    wl-clipboard
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    #SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };
}
