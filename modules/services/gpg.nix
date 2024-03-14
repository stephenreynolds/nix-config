# TODO: figure out where to put this
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.gpg;

  pinentry = if config.hm.gtk.enable then {
    packages = [ pkgs.pinentry-gnome3 pkgs.gcr ];
    name = "gnome3";
  } else {
    packages = [ pkgs.pinentry-curses ];
    name = "curses";
  };
in {
  options.modules.services.gpg = {
    enable = lib.mkEnableOption "Enable GPG agent";
  };

  config = lib.mkIf cfg.enable {
    hm.home.packages = pinentry.packages;

    hm.services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = null;
      enableExtraSocket = true;
    };

    hm.programs = let
      fixGpg = ''
        gpgconf --launch gpg-agent
      '';
    in {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      bash.profileExtra = fixGpg;
      fish.loginShellInit = fixGpg;
      zsh.loginExtra = fixGpg;

      gpg = {
        enable = true;
        homedir = "${config.hm.xdg.dataHome}/gnupg";
        settings = { trust-model = "tofu+pgp"; };
      };
    };

    hm.systemd.user.services = {
      link-gnupg-sockets = {
        Unit = { Description = "Link gnupg sockets from /run to /home"; };
        Service = {
          Type = "oneshot";
          ExecStart =
            "${pkgs.coreutils}/bin/ln -Tfs /run/user/%U/gnupg %h/.gnupg-socket";
          ExecStop = "${pkgs.coreutils}/bin/rm $HOME/.gnupg-sockets";
          RemainAfterExit = true;
        };
        Install.WantedBy = [ "default.target" ];
      };
    };

    modules.system.persist.state.home.directories = [{
      directory = ".local/share/gnupg";
      mode = "0700";
    }];
  };
}
