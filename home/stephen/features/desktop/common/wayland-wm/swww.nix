{ pkgs, ... }:
let
  wallpapers-path = "/home/stephen/Pictures/Wallpapers/Slideshow";

  wallpaper-randomizer = pkgs.writeShellScript "wallpaper-randomizer" ''
    # Edit bellow to control the images transition
    TRANSITION_FPS=30
    TRANSITION_STEP=90
    TRANSITION_TYPE=random

    # This controls (in seconds) when to switch to the next image
    INTERVAL=3600

    while true; do
      ${pkgs.findutils}/bin/find "${wallpapers-path}" \
        | while read -r img; do
          echo "$((RANDOM % 1000)):$img"
        done \
        | ${pkgs.coreutils}/bin/sort -n | ${pkgs.coreutils}/bin/cut -d':' -f2- \
        | while read -r img; do
          ${pkgs.swww}/bin/swww img "$img" \
            --transition-type $TRANSITION_TYPE \
            --transition-step $TRANSITION_STEP \
            --transition-fps $TRANSITION_FPS
          ${pkgs.coreutils}/bin/sleep $INTERVAL
        done
    done
  '';
in
{
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland compositor daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      ExecStartPost = "${wallpaper-randomizer}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
