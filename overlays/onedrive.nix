final: prev: {
  onedrive = prev.onedrive.overrideAttrs (old: rec {
    version = "2.5.2";

    src = prev.fetchFromGitHub
      {
        owner = "abraunegg";
        repo = "onedrive";
        rev = "v${version}";
        hash = "sha256-neJi5lIx45GsuwZPzzwwEm1bfrL2DFSysVkxa4fCBww";
      };
  });
}
