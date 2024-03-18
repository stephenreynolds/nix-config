{ tmuxPlugins, fetchFromGitHub }:
tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-transient-status";
  version = "c3fcd5180999a7afc075d2dd37d37d1b1b82f7e8";
  rtpFilePath = "main.tmux";
  src = fetchFromGitHub {
    owner = "TheSast";
    repo = "tmux-transient-status";
    rev = version;
    sha256 = "fOIn8hVVBDFVLwzmPZP+Bf3ccxy/hsAnKIXYD9yv3BE=";
  };
}
