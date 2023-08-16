{ pkgs, ... }:
{
  imports = [
    ./waybar.nix
    ./kitty.nix
    ./mako.nix
    ./swayidle.nix
    ./swaylock.nix
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
    swww
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  services.gnome-policykit-agent.enable = true;
}
