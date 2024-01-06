{ pkgs, ... }:

{
  my = {
    apps = {
      firefox = {
        enable = true;
        defaultBrowser = true;
        vaapi.enable = true;
        extraProfileConfig.stephen = {
          userChrome = {
            onebar = true;
            hideBloat = true;
          };
          settings = {
            hideBookmarksToolbar = true;
            harden = true;
          };
          search = {
            default = "Brave";
            brave = true;
            phind = true;
            youtube = true;
            github = true;
            sourcegraph = true;
            nix-packages = true;
            nix-options = true;
          };
        };
      };
    };
    services = {
      onedrive.enable = true;
    };
    user = {
      name = "stephen";
    };
  };

  home.packages = [ pkgs.blackbox-terminal ];
}
