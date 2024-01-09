{ config, lib, pkgs, ... }:

let cfg = config.my.cli.wsl;
in {
  options.my.cli.wsl = {
    enable = lib.mkEnableOption "Whether to set options for WSL";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wslu ];

    home.sessionVariables.BROWSER = "${pkgs.wslu}/bin/wslview";

    programs.git.extraConfig = {
      credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
    };
  };
}
