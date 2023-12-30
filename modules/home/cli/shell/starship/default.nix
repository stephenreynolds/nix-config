{ config, lib, ... }:

let cfg = config.my.cli.shell.starship;
in {
  options.my.cli.shell.starship = {
    enable = lib.mkEnableOption "Enable Starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = {
        add_newline = true;

        character.success_symbol = "[λ](bold green)";

        package.disabled = true;

        bun.format = "via [$symbol]($style)";
        buf.format = "via [$symbol]($style)";
        cmake.format = "via [$symbol]($style)";
        cobol.format = "via [$symbol]($style)";
        crystal.format = "via [$symbol]($style)";
        daml.format = "via [$symbol]($style)";
        dart.format = "via [$symbol]($style)";
        deno.format = "via [$symbol]($style)";
        dotnet.format = "[$symbol(🎯 $tfm )]($style)";
        elixir.format = "via [$symbol]($style)";
        elm.format = "via [$symbol]($style)";
        erlang.format = "via [$symbol]($style)";
        fennel.format = "via [$symbol]($style)";
        golang.format = "via [$symbol]($style)";
        gradle.format = "via [$symbol]($style)";
        haxe.format = "via [$symbol]($style)";
        helm.format = "via [$symbol]($style)";
        julia.format = "via [$symbol]($style)";
        kotlin.format = "via [$symbol]($style)";
        lua.format = "via [$symbol]($style)";
        meson.format = "via [$symbol]($style)";
        nim.format = "via [$symbol]($style)";
        nodejs.format = "via [$symbol]($style)";
        ocaml.format = "via [$symbol(\\($switch_indicator$switch_name\\) )]($style)";
        opa.format = "via [$symbol]($style)";
        perl.format = "via [$symbol]($style)";
        php.format = "via [$symbol]($style)";
        pulumi.format = "via [$symbol$stack]($style)";
        purescript.format = "via [$symbol]($style)";
        python.format = "via [$symbol]($style)";
        raku.format = "via [$symbol]($style)";
        red.format = "via [$symbol]($style)";
        rlang.format = "via [$symbol]($style)";
        ruby.format = "via [$symbol]($style)";
        rust.format = "via [$symbol]($style)";
        swift.format = "via [$symbol]($style)";
        vagrant.format = "via [$symbol]($style)";
        vlang.format = "via [$symbol]($style)";
        zig.format = "via [$symbol]($style)";

        # TODO: Set palette through config option
        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };

        palette = "catppuccin_mocha";
      };
    };
  };
}
