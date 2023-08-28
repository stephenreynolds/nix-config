{
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  home.persistence = {
    "/persist/home/stephen".directories = [
      ".local/share/keyrings"
    ];
  };
}
