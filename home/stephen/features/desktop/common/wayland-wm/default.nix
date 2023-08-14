{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./mako.nix
    ./swayidle.nix
    ./swaylock.nix
    ./wofi.nix
    ./zathura.nix
  ];

  xdg.mimeApps.enable = true;
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
  };
}
