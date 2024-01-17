{ config, ... }:

{
  config = { hm.home = { stateVersion = config.system.stateVersion; }; };
}
