{ lib, writeShellApplication, tmux, zoxide }:
(writeShellApplication {
  name = "t";
  runtimeInputs = [ tmux zoxide ];
  text = builtins.readFile ./t.sh;
}) // {
  meta = with lib; {
    description =
      "A shell script that makes jumping into tmux session easy using zoxide.";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ stephenreynolds ];
  };
}
