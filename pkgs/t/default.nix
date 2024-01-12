{ lib, writeShellApplication, tmux, zoxide }:
(writeShellApplication {
  name = "t";
  runtimeInputs = [ tmux zoxide ];
  text = builtins.readFile ./t.sh;
}) // {
  meta = {
    description = "A shell script that makes jumping into tmux session easy using zoxide.";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ stephenreynolds ];
  };
}
