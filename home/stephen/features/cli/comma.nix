{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    comma
  ];

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  systemd.user.services.nix-update-index = {
    Unit = {
      Description = "Update nix-index";
    };

    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe (
        pkgs.writeShellScriptBin "nix-update-index" ''
          filename="index-${pkgs.system}"
          release="https://github.com/Mic92/nix-index-database/releases/latest/download/''${filename}"

          mkdir -p ~/.cache/nix-index

          pushd ~/.cache/nix-index > /dev/null

          ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename

          ln -f ''${filename} files

          popd > /dev/null
        ''
      );
    };
  };

  systemd.user.timers.nix-update-index = {
    Unit = {
      Description = "Update nix-index";
    };

    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
