{ pkgs, lib, config, ... }: {
  home.packages = with pkgs; [ comma ];

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  systemd.user.services.nix-update-index = {
    Unit = { Description = "Update nix-index"; };

    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe (pkgs.writeShellApplication {
        name = "nix-index-update";

        runtimeInputs = with pkgs; [ coreutils wget ];

        text = ''
          readonly filename="index-${pkgs.system}"
          readonly release="https://github.com/Mic92/nix-index-database/releases/latest/download/$filename"
          readonly indexDir="${config.xdg.cacheHome}/nix-index"

          mkdir -p "$indexDir"

          pushd "$indexDir" > /dev/null

          trap "popd > /dev/null" EXIT

          wget -q -N "$release"

          ln -f "$filename" files

          echo "Finished updating nix-index"
        '';
      });
    };
  };

  systemd.user.timers.nix-update-index = {
    Unit = { Description = "Update nix-index"; };

    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
