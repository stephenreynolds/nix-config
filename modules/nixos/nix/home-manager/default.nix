{ config, ... }:

{
  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users = builtins.mapAttrs
        (_: _: {
          home.stateVersion = config.system.stateVersion;
        })
        config.my.users.users;
    };
  };
}
