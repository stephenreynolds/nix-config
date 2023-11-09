{ lib, writeShellApplication, tmux, zoxide, fzf }:
(writeShellApplication {
  name = "tt";
  runtimeInputs = [ tmux zoxide fzf ];
  text = builtins.readFile ./tt.sh;
}) // {
  meta = with lib; {
    description =
      "A shell script that fuzzy finds directories and opens them in a tmux session";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ stephenreynolds ];
  };
}
