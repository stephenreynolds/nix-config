final: prev: {
  discord =
    let
      nss =
        if final.stdenv.buildPlatform.isLinux
        then { nss = prev.nss_latest; }
        else { };
    in
    prev.discord.override ({ withOpenASAR = true; } // nss);
}
