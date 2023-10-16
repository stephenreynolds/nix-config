{ pkgs, ... }:
{
  imports = [
    ./lutris.nix
    ./steam.nix
    ./yuzu.nix
  ];

  home.packages = with pkgs; [
    gamescope
    mangohud
    protontricks
  ];

  home.sessionVariables = {
    VKD3D_CONFIG = "dxr11,dxr";
    PROTON_ENABLE_NVAPI = 1;
    PROTON_ENABLE_NGX_UPDATER = 1;
    PROTON_HIDE_NVIDIA_GPU = 0;
  };
}
