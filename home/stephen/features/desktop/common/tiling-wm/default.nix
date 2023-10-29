{ pkgs, ... }: {
  imports = [
    ./autotrash.nix
    ./deluge.nix
    ./firefox.nix
    ./gtk.nix
    ./imv.nix
    ./kitty.nix
    ./nemo.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./qt.nix
    ./zathura.nix
  ];

  xdg = {
    enable = true;
    mimeApps.enable = true;
    userDirs.enable = true;
    configFile."mimeapps.list".force = true;
  };

  home.packages = with pkgs; [ gtk3 xdg-utils pulseaudio ];

  services.gnome-policykit-agent.enable = true;

  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
}
