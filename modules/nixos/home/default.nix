{ config, lib, ... }:

let cfg = config.my.home;
in
{
  options.my.home = {
    extraOptions = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Options to pass to home-manager";
    };
  };

  config = {
    my.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      xdg.enable = true;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users = builtins.mapAttrs
        (_: _: cfg.extraOptions)
        config.my.users.users;
    };
  };
}
