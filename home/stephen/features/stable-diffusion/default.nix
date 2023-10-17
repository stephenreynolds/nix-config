{ config, ... }:
{
  xdg.desktopEntries.stable-diffusion-webui = {
    name = "Stable Diffusion Web UI";
    exec = "kitty -d ${config.home.homeDirectory}/src/cloned/stable-diffusion-webui nix develop -c ${config.home.homeDirectory}/src/cloned/stable-diffusion-webui/webui.sh";
    icon = ./icon.png;
    type = "Application";
  };

  xdg.desktopEntries.comfyui = {
    name = "ComfyUI";
    exec = "kitty -d ${config.home.homeDirectory}/src/cloned/ComfyUI nix develop -c ${config.home.homeDirectory}/src/cloned/ComfyUI/start.sh";
    type = "Application";
  };

  nix.settings = {
    trusted-substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
  };
}
