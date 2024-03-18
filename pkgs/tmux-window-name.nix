{ tmuxPlugins, lib, fetchFromGitHub, makeWrapper, python3 }:
tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-window-name";
  version = "2024-03-08";
  src = fetchFromGitHub {
    owner = "ofirgall";
    repo = "tmux-window-name";
    rev = "34026b6f442ceb07628bf25ae1b04a0cd475e9ae";
    sha256 = "sha256-BNgxLk/BkaQkGlB4g2WKVs39y4VHL1Y2TdTEoBy7yo0=";
  };
  nativeBuildInputs = [ makeWrapper ];
  rtpFilePath = "tmux_window_name.tmux";
  postInstall = ''
    NIX_BIN_PATH="${builtins.getEnv "HOME"}/.nix-profile/bin"
    # Update USR_BIN_REMOVER with .nix-profile PATH
    sed -i "s|^USR_BIN_REMOVER.*|USR_BIN_REMOVER = (r\'^$NIX_BIN_PATH/(.+)( --.*)?\', r\'\\\g<1>\')|" $target/scripts/rename_session_windows.py

    # Update substitute_sets with .nix-profile PATHs
    sed -i "s|^\ssubstitute_sets: List.*|    substitute_sets: List[Tuple] = field(default_factory=lambda: [(\'/$NIX_BIN_PATH/(.+) --.*\', \'\\\g<1>\'), (r\'.+ipython([32])\', r\'ipython\\\g<1>\'), USR_BIN_REMOVER, (r\'(bash) (.+)/(.+[ $])(.+)\', \'\\\g<3>\\\g<4>\')])|" $target/scripts/rename_session_windows.py

    # Update dir_programs with .nix-profile PATH for applications
    sed -i "s|^\sdir_programs: List.*|    dir_programs: List[str] = field(default_factory=lambda: [["$NIX_BIN_PATH/vim", "$NIX_BIN_PATH/vi", "$NIX_BIN_PATH/git", "$NIX_BIN_PATH/nvim"]])|" $target/scripts/rename_session_windows.py

    for f in tmux_window_name.tmux scripts/rename_session_windows.py; do
      wrapProgram $target/$f \
        --prefix PATH : ${
          lib.makeBinPath
          [ (python3.withPackages (p: with p; [ libtmux pip ])) ]
        }
    done
  '';
  meta = with lib; {
    homepage = "https://github.com/ofirgall/tmux-window-name";
    description = "A plugin to name your tmux windows smartly, like IDE's";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ndom91 ];
  };
}
