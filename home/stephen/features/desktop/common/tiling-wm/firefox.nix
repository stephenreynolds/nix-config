{
  programs.firefox.profiles.stephen.userChrome = ''
    /* Hide the close button */
    .titlebar-buttonbox-container { display:none }
    .titlebar-spacer[type="post-tabs"] { display:none }
  '';
}
