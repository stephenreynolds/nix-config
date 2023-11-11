final: prev: {
  discocss = prev.discocss.overrideAttrs
    (old: rec {
      version = "0.3.0";
      src = prev.fetchFromGitHub {
        owner = "bddvlpr";
        repo = "discocss";
        rev = "v${version}";
        hash = "sha256-2K7SPTvORzgZ1ZiCtS5TOShuAnmtI5NYkdQPRXIBP/I=";
      };
    });
}
