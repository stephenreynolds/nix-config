{ lib, writeShellApplication, tmux, zoxide, fzf }:

(writeShellApplication {
  name = "tt";
  runtimeInputs = [ tmux zoxide fzf ];
  text = builtins.readFile ./tt.sh;
}) // {
  meta = {
    description =
      "A shell script that fuzzy finds directories and opens them in a tmux session";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ stephenreynolds ];
  };
}
