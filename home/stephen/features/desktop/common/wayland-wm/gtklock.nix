{ pkgs, lib, ... }:
let
  lock = pkgs.writeShellScriptBin "lock" ''
    wallpaper=$(${lib.getExe pkgs.swww} query | awk -F'image: ' 'NR==1 {print $2}')
    image=$(${pkgs.imagemagick}/bin/convert $wallpaper -blur 0x50 /tmp/lock.jpg && echo /tmp/lock.jpg)
    ${lib.getExe pkgs.gtklock} -b $image
  '';
in
{
  programs.gtklock = {
    enable = true;
    config = {
      modules = [
        "${pkgs.gtklock-powerbar-module.outPath}/lib/gtklock/powerbar-module.so"
      ];

      style = pkgs.writeText "gtklock-style.css" ''
        window {
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
        }

        #clock-label {
          margin-botton: 30px;
          font-size: 800%;
          font-weight: bold;
          color: white;
          text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        #body {
          margin-top: 50px;
        }

        #unlock-button {
          all: unset;
          color: transparent;
        }

        entry {
          border-radius: 12px;
          margin: 1px;
          box-shadow: 1px 2px 4px rgba(0, 0, 0, 0.1);
        }

        #input-label {
          color: transparent;
          margin: -20rem;
        }

        #powerbar-box * {
          border-radius: 12px;
          box-shadow: 1px 2px 4px rgba(0, 0, 0, 0.1);
        }
      '';
    };
    extraConfig = {
      main = {
        time-format = "%-I:%M %p";
        start-hidden = true;
        idle-hide = true;
        idle-timeout = 30;
      };
    };
  };

  home.packages = [ lock ];
}
