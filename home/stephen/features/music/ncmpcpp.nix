{
  programs.ncmpcpp = {
    enable = true;
    settings = {
      ncmpcpp_directory = "${xdg.configHome}/ncmpcpp";

      mpd_host = "localhost";
      mpd_port = 6600;

      audio_output = {
        type = "fifo";
        name = "Visualizer feed";
        path = "/tmp/mpd.fifo";
        format = "44100:16:2"
      };

      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = true;
      visualizer_type = "spectrum";
      visualizer_look = "▮▮";
      visualizer_spectrum_smooth_look = true;
      visualizer_color = "blue, cyan, green, yellow, magenta, red, black";

      song_list_format = "{$7%a - $9}{$5%t$9}$R{$6%b $9}{$3%l$9}";

      user_interface = "alternative";

      alternative_header_first_line_format = "$0$aqqu$/a {$6%t$9 - }{$3%a$9}|{$3%f$9} $0$atqq$/a$9";
      alternative_header_second_line_format = "{{$4%b$9}{ [$8%y$9]}}|{$4%D$9}";

      current_item_prefix = "$(cyan)$r";
      current_item_suffix = "$/r$(end)";
      now_playing_prefix = "> $b";

      song_columns_list_format = "(10)[blue]{l} (30)[green]{t} (30)[yellow]{b} (30)[magenta]{a}";

      media_library_albums_split_by_date = false;
      media_library_hide_albums_dates = true;

      ignore_leading_the = true;

      volume_color = "green";
      main_window_color = "white";
      statusbar_color = "white";

      discard_colors_if_item_is_selected = true;

      generate_win32_compatible_filenames = true;

      allow_for_physical_item_deletion = false;

      progressbar_look = "▂▂▂";
      progressbar_color = "black";
      progressbar_elapsed_color = "cyan";

      startup_screen = "visualizer";
      startup_slave_screen = "playlist";
      startup_slave_screen_focus = true;
      locked_screen_width_part = 41;
    };
  };
}
