{ config, ... }:
{
  xdg.desktopEntries.stable-diffusion-webui = {
    name = "Stable Diffusion Web UI";
    exec = "kitty -d ${config.home.homeDirectory}/src/cloned/stable-diffusion-webui nix develop -c ${config.home.homeDirectory}/src/cloned/stable-diffusion-webui/webui.sh";
    icon = ./icon.png;
    type = "Application";
  };
}
