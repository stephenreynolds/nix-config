{ pkgs, ... }:

{
  modules.system.persist.state.home.directories = [ "Downloads" ];

  hm.systemd.user.services.persist-trash = {
    Unit.Description = "Persist Trash Folder";
    Install.WantedBy = [ "default.target" ];
    Service = let
      dir = ''
        LOCAL="$HOME/.local/share/Trash"
        PERSIST="/persist/home/$USER/.local/share/Trash"
        mkdir -p "$LOCAL"
      '';
    in {
      Type = "oneshot";
      RemainAfterExit = true;
      StandardOutput = "journal";
      ExecStart = "${
          pkgs.writeShellApplication {
            name = "retrieve";
            runtimeInputs = [ pkgs.coreutils ];
            text = ''
              ${dir}
              if [ -d "$PERSIST" ]
              then
                cp -r "$PERSIST"/. "$LOCAL"
                rm -rf "$PERSIST"
              fi
            '';
          }
        }/bin/retrieve";
      ExecStop = "${
          pkgs.writeShellApplication {
            name = "migrate";
            runtimeInputs = [ pkgs.coreutils ];
            text = ''
              ${dir}
              mkdir -p "$PERSIST"
              cp -r "$LOCAL"/. "$PERSIST"
            '';
          }
        }/bin/migrate";
    };
  };
}
