{ tmuxPlugins, fetchFromGitHub }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tokyo-night-tmux";
  version = "6189acc8b3c76afd545b824494884684f57b714d";
  rtpFilePath = "tokyo-night.tmux";
  src = fetchFromGitHub {
    owner = "janoamaral";
    repo = "tokyo-night-tmux";
    rev = version;
    sha256 = "am3qcVJOt27gpu1UQ+o1jPnCX68kDzSHvER12Lh2cvY=";
  };
}
