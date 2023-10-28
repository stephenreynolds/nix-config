{ config, lib, ... }: {
  boot = {
    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
    };
  };
}
