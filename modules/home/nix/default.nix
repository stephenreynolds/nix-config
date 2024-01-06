{
  nixpkgs = {
    config = {
      allowUnfree = true;
      # HACK: fixes obsidian until its version of electron is updated
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
}
