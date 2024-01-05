{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  my = {
    system = {
      boot = {
        initrd.systemd.enable = true;
        iommu.enable = true;
      };
      locale.time.timeZone = "America/Detroit";
    };
    users = {
      users.stephen = {
        shell = pkgs.fish;
        extraGroups = [ "wheel" "input" "audio" "video" "storage" ];
        optionalGroups = [
          "i2c"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "mlocate"
          "flatpak"
          "tss"
          "libvirtd"
          "gamemode"
          "nix-access-tokens"
          "openai-api-key"
        ];
      };
    };
  };
}
