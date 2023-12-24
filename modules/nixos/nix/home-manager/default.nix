{ config, ... }:

{
  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.my.user.name}.home.stateVersion = config.system.stateVersion;
    };
  };
}
